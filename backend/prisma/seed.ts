import { PrismaClient, WorkspaceRole, MeetingType, MeetingStatus, TaskType, TaskStatus, TaskPriority } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('Starting database seeding...');

  // 1. Clean existing database records in reverse dependency order
  console.log('Cleaning up existing database records...');
  
  await prisma.ticketSLA.deleteMany();
  await prisma.ticketComment.deleteMany();
  await prisma.helpdeskTicket.deleteMany();
  
  await prisma.budget.deleteMany();
  await prisma.invoice.deleteMany();
  await prisma.expense.deleteMany();
  
  await prisma.assetMaintenance.deleteMany();
  await prisma.eRPAsset.deleteMany();
  
  await prisma.inventoryAdjustment.deleteMany();
  await prisma.stockTransfer.deleteMany();
  await prisma.inventoryItem.deleteMany();
  await prisma.warehouse.deleteMany();
  
  await prisma.purchaseOrder.deleteMany();
  await prisma.purchaseRequest.deleteMany();
  await prisma.eRPVendor.deleteMany();
  
  await prisma.cRMOpportunity.deleteMany();
  await prisma.cRMLead.deleteMany();
  await prisma.cRMAccount.deleteMany();
  await prisma.cRMContact.deleteMany();
  
  await prisma.meetingParticipant.deleteMany();
  await prisma.taskMeeting.deleteMany();
  await prisma.meetingNote.deleteMany();
  await prisma.meetingDecision.deleteMany();
  await prisma.meetingRecording.deleteMany();
  await prisma.meetingTranscript.deleteMany();
  await prisma.meetingWaitingRoom.deleteMany();
  await prisma.meeting.deleteMany();
  
  await prisma.documentContent.deleteMany();
  await prisma.documentPresence.deleteMany();
  await prisma.documentComment.deleteMany();
  await prisma.documentPermission.deleteMany();
  await prisma.documentVersion.deleteMany();
  await prisma.documentFavorite.deleteMany();
  await prisma.documentAttachment.deleteMany();
  await prisma.document.deleteMany();
  
  await prisma.taskCustomFieldValue.deleteMany();
  await prisma.taskActivity.deleteMany();
  await prisma.taskComment.deleteMany();
  await prisma.taskWatcher.deleteMany();
  await prisma.taskAttachment.deleteMany();
  await prisma.taskLabel.deleteMany();
  await prisma.taskDependency.deleteMany();
  await prisma.task.deleteMany();
  
  await prisma.sprint.deleteMany();
  await prisma.projectMember.deleteMany();
  await prisma.kanbanColumnSetting.deleteMany();
  await prisma.project.deleteMany();
  
  await prisma.workspaceSeat.deleteMany();
  await prisma.userSession.deleteMany();
  await prisma.workspaceMember.deleteMany();
  await prisma.userPresence.deleteMany();
  await prisma.featureFlag.deleteMany();
  await prisma.workspaceSettings.deleteMany();
  await prisma.workspace.deleteMany();
  
  await prisma.department.deleteMany();
  await prisma.organization.deleteMany();
  
  await prisma.employee.deleteMany();
  await prisma.user.deleteMany();

  console.log('Database cleanup completed.');

  // 2. Create 1 Enterprise Organization
  console.log('Creating organization...');
  const org = await prisma.organization.create({
    data: {
      name: 'TeamOS Enterprise Corp',
      domain: 'teamos.com',
    },
  });

  // 3. Create 1 Enterprise Workspace
  console.log('Creating workspace...');
  const workspace = await prisma.workspace.create({
    data: {
      name: 'TeamOS Enterprise Workspace',
      slug: 'teamos-enterprise-workspace',
      ownerId: 'placeholder-owner-id', // We will update this or set it to first admin
      plan: 'ENTERPRISE',
      subscriptionStatus: 'ACTIVE',
      organizationId: org.id,
    },
  });

  // 4. Create 7 Departments
  console.log('Creating departments...');
  const departmentNames = [
    'Engineering',
    'HR',
    'Finance',
    'Operations',
    'Procurement',
    'Sales',
    'Support',
  ];
  const departments: any[] = [];
  for (const name of departmentNames) {
    const dept = await prisma.department.create({
      data: {
        organizationId: org.id,
        name,
      },
    });
    departments.push(dept);
  }

  // 5. Create 65 Users (5 Admins, 10 Managers, 50 Employees)
  console.log('Creating users and workspace memberships...');
  const admins: any[] = [];
  const managers: any[] = [];
  const employees: any[] = [];

  // Create 5 Admins
  for (let i = 1; i <= 5; i++) {
    const user = await prisma.user.create({
      data: {
        email: `admin${i}@teamos.com`,
        fullName: `Admin ${i}`,
        passwordHash: '$2b$10$EPf9X86P5P9z84V6wL/r5Ok9q3l1N7G38K69P0.D7D0m3o7N3.8u2', // 'password'
      },
    });
    await prisma.workspaceMember.create({
      data: {
        workspaceId: workspace.id,
        userId: user.id,
        role: WorkspaceRole.ADMIN,
      },
    });
    admins.push(user);
  }

  // Set workspace owner to first admin
  await prisma.workspace.update({
    where: { id: workspace.id },
    data: { ownerId: admins[0].id },
  });

  // Create 10 Managers
  for (let i = 1; i <= 10; i++) {
    const user = await prisma.user.create({
      data: {
        email: `manager${i}@teamos.com`,
        fullName: `Manager ${i}`,
        passwordHash: '$2b$10$EPf9X86P5P9z84V6wL/r5Ok9q3l1N7G38K69P0.D7D0m3o7N3.8u2',
      },
    });
    await prisma.workspaceMember.create({
      data: {
        workspaceId: workspace.id,
        userId: user.id,
        role: WorkspaceRole.MANAGER,
      },
    });
    managers.push(user);
  }

  // Assign managers to departments (Manager 1-7 for the 7 departments)
  for (let i = 0; i < departmentNames.length; i++) {
    await prisma.department.update({
      where: { id: departments[i].id },
      data: { managerId: managers[i].id },
    });
  }

  // Create 50 Employees
  for (let i = 1; i <= 50; i++) {
    const user = await prisma.user.create({
      data: {
        email: `employee${i}@teamos.com`,
        fullName: `Employee ${i}`,
        passwordHash: '$2b$10$EPf9X86P5P9z84V6wL/r5Ok9q3l1N7G38K69P0.D7D0m3o7N3.8u2',
      },
    });
    await prisma.workspaceMember.create({
      data: {
        workspaceId: workspace.id,
        userId: user.id,
        role: WorkspaceRole.DEVELOPER,
      },
    });
    employees.push(user);
  }

  const allUsers = [...admins, ...managers, ...employees];

  // 6. Create HRMS Employee Profiles for all 65 users
  console.log('Creating employee profiles...');
  const employeeProfiles: any[] = [];
  for (let i = 0; i < allUsers.length; i++) {
    const user = allUsers[i];
    let role = 'Employee';
    let deptName = departmentNames[i % departmentNames.length];
    let salary = 60000 + (i * 2000);

    if (admins.includes(user)) {
      role = 'Administrator';
      deptName = 'Operations';
      salary = 120000 + (i * 5000);
    } else if (managers.includes(user)) {
      role = 'Manager';
      const managerIndex = managers.indexOf(user);
      if (managerIndex < departmentNames.length) {
        deptName = departmentNames[managerIndex];
      }
      salary = 90000 + (i * 3000);
    }

    const employee = await prisma.employee.create({
      data: {
        workspaceId: workspace.id,
        userId: user.id,
        fullName: user.fullName,
        email: user.email,
        role,
        department: deptName,
        salary,
        status: 'ACTIVE',
      },
    });
    employeeProfiles.push(employee);
  }

  // 7. Create 20 Projects
  console.log('Creating projects...');
  const projects: any[] = [];
  for (let i = 1; i <= 20; i++) {
    const proj = await prisma.project.create({
      data: {
        workspaceId: workspace.id,
        name: `Project ${i}`,
        key: `PRJ${i}`,
        description: `This is the description for Project ${i}`,
        status: 'ACTIVE',
      },
    });
    projects.push(proj);
  }

  // 8. Create 200 Tasks
  console.log('Creating tasks...');
  const tasks: any[] = [];
  for (let i = 1; i <= 200; i++) {
    const projectIndex = (i - 1) % projects.length;
    const project = projects[projectIndex];
    const assignee = employees[(i - 1) % employees.length];
    const reporter = managers[(i - 1) % managers.length];

    const task = await prisma.task.create({
      data: {
        projectId: project.id,
        key: `${project.key}-${100 + i}`,
        title: `Task ${i} - ${project.name}`,
        description: `Detailed requirements for task number ${i}.`,
        type: TaskType.TASK,
        status: i % 4 === 0 ? TaskStatus.DONE : i % 3 === 0 ? TaskStatus.IN_PROGRESS : TaskStatus.TODO,
        priority: i % 5 === 0 ? TaskPriority.CRITICAL : i % 2 === 0 ? TaskPriority.HIGH : TaskPriority.MEDIUM,
        assigneeId: assignee.id,
        reporterId: reporter.id,
        dueDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days from now
      },
    });
    tasks.push(task);
  }

  // 9. Create 100 Documents
  console.log('Creating documents...');
  const docs: any[] = [];
  for (let i = 1; i <= 100; i++) {
    const creator = allUsers[i % allUsers.length];
    const project = projects[i % projects.length];

    const doc = await prisma.document.create({
      data: {
        workspaceId: workspace.id,
        projectId: i % 2 === 0 ? project.id : null,
        title: `Document ${i}`,
        slug: `document-${i}`,
        createdBy: creator.id,
        updatedBy: creator.id,
        isPublished: true,
      },
    });
    docs.push(doc);
  }

  // 10. Create 50 Meetings
  console.log('Creating meetings...');
  const meetings: any[] = [];
  for (let i = 1; i <= 50; i++) {
    const host = managers[i % managers.length];
    const project = projects[i % projects.length];

    const meeting = await prisma.meeting.create({
      data: {
        workspaceId: workspace.id,
        projectId: i % 2 === 0 ? project.id : null,
        title: `Meeting ${i} - Sync`,
        description: `Agenda and status checks for sync meeting ${i}.`,
        meetingType: MeetingType.SCHEDULED,
        status: MeetingStatus.SCHEDULED,
        hostId: host.id,
        roomName: `room-meeting-uid-${i}-${Math.random().toString(36).substring(2, 7)}`,
      },
    });
    meetings.push(meeting);
  }

  // 11. Create CRM Data (100 Leads, 50 Opportunities)
  console.log('Creating CRM data...');
  const leads: any[] = [];
  for (let i = 1; i <= 100; i++) {
    const lead = await prisma.cRMLead.create({
      data: {
        workspaceId: workspace.id,
        name: `Lead Contact ${i}`,
        company: `Corporate Client ${i} Inc`,
        email: `lead${i}@corporate${i}.com`,
        status: i % 3 === 0 ? 'QUALIFIED' : i % 2 === 0 ? 'CONTACTED' : 'NEW',
        value: 5000 + (i * 250),
        aiScore: 40 + (i % 55),
      },
    });
    leads.push(lead);
  }

  for (let i = 1; i <= 50; i++) {
    const lead = leads[i - 1];
    await prisma.cRMOpportunity.create({
      data: {
        workspaceId: workspace.id,
        leadId: lead.id,
        name: `Deal for ${lead.company}`,
        stage: i % 4 === 0 ? 'CLOSED_WON' : i % 3 === 0 ? 'PROPOSAL' : 'PROSPECTING',
        value: lead.value * 1.2,
        probability: i % 4 === 0 ? 1.0 : i % 3 === 0 ? 0.6 : 0.2,
      },
    });
  }

  // 12. Create Procurement (20 Vendors, 30 Purchase Requests)
  console.log('Creating procurement data...');
  const vendors: any[] = [];
  for (let i = 1; i <= 20; i++) {
    const vendor = await prisma.eRPVendor.create({
      data: {
        workspaceId: workspace.id,
        name: `Vendor Partner ${i}`,
        email: `contact@vendor${i}.com`,
        phone: `+1-555-01${10 + i}`,
        status: 'ACTIVE',
        riskRating: i % 5 === 0 ? 'HIGH' : i % 3 === 0 ? 'MEDIUM' : 'LOW',
      },
    });
    vendors.push(vendor);
  }

  for (let i = 1; i <= 30; i++) {
    const requester = employees[i % employees.length];
    await prisma.purchaseRequest.create({
      data: {
        workspaceId: workspace.id,
        item: `Office Resource Item ${i}`,
        quantity: 2 + (i % 10),
        estimatedCost: 150.0 * i,
        status: i % 3 === 0 ? 'APPROVED' : i % 2 === 0 ? 'PENDING' : 'DRAFT',
        requestedBy: requester.id,
      },
    });
  }

  // 13. Create Inventory (5 Warehouses, 200 Inventory Items)
  console.log('Creating inventory data...');
  const warehouses: any[] = [];
  for (let i = 1; i <= 5; i++) {
    const wh = await prisma.warehouse.create({
      data: {
        workspaceId: workspace.id,
        name: `Warehouse Hub ${i}`,
        location: `Zone ${i} Distribution Park`,
      },
    });
    warehouses.push(wh);
  }

  for (let i = 1; i <= 200; i++) {
    const warehouse = warehouses[i % warehouses.length];
    await prisma.inventoryItem.create({
      data: {
        workspaceId: workspace.id,
        name: `Inventory Stock Item ${i}`,
        sku: `SKU-${1000 + i}`,
        quantity: 50 + (i * 3),
        warehouseId: warehouse.id,
      },
    });
  }

  // 14. Create Finance (50 Expenses, 30 Invoices)
  console.log('Creating finance data...');
  for (let i = 1; i <= 50; i++) {
    const profile = employeeProfiles[i % employeeProfiles.length];
    await prisma.expense.create({
      data: {
        workspaceId: workspace.id,
        amount: 25.0 * i,
        category: i % 4 === 0 ? 'Travel' : i % 3 === 0 ? 'Software' : 'Office Supplies',
        status: i % 2 === 0 ? 'APPROVED' : 'PENDING',
        employeeId: profile.id,
      },
    });
  }

  for (let i = 1; i <= 30; i++) {
    await prisma.invoice.create({
      data: {
        workspaceId: workspace.id,
        amount: 1200.0 * i,
        status: i % 3 === 0 ? 'PAID' : 'UNPAID',
        customerName: `Client Organization ${i}`,
        dueDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
      },
    });
  }

  // 15. Create Helpdesk (100 Tickets with SLA records)
  console.log('Creating helpdesk tickets and SLA configurations...');
  for (let i = 1; i <= 100; i++) {
    const agent = employees[i % employees.length];
    const ticket = await prisma.helpdeskTicket.create({
      data: {
        workspaceId: workspace.id,
        title: `Service Request Ticket ${i}`,
        description: `Customer is requesting support regarding issue details for item ${i}.`,
        status: i % 4 === 0 ? 'RESOLVED' : i % 3 === 0 ? 'IN_PROGRESS' : 'OPEN',
        priority: i % 3 === 0 ? 'HIGH' : 'MEDIUM',
        assignedTo: agent.id,
      },
    });

    await prisma.ticketSLA.create({
      data: {
        ticketId: ticket.id,
        targetHours: i % 3 === 0 ? 4 : 24,
        breached: i % 7 === 0, // Mark a few as breached for analytics
      },
    });
  }

  console.log('Database seeding successfully completed!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
