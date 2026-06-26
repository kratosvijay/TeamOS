import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class WidgetBuilderScreen extends StatefulWidget {
  const WidgetBuilderScreen({super.key});

  @override
  State<WidgetBuilderScreen> createState() => _WidgetBuilderScreenState();
}

class _WidgetBuilderScreenState extends State<WidgetBuilderScreen> {
  String _widgetName = 'Sales Performance';
  String _selectedType = 'Bar Chart';
  String _endpoint = '/api/v1/erp/sales';
  String _size = 'Medium';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Row(
        children: [
          const SidebarWidget(isCollapsed: false),
          Expanded(
            child: Column(
              children: [
                const TopBarWidget(),
                Expanded(
                  child: Row(
                    children: [
                      // Config Panel (Left)
                      Expanded(
                        flex: 2,
                        child: Container(
                          color: const Color(0xFF1E293B),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () => context.go('/developer'),
                                child: const Row(
                                  children: [
                                    Icon(Icons.arrow_back_rounded, color: Color(0xFF3B82F6), size: 16),
                                    SizedBox(width: 4),
                                    Text('Back to Developer Portal', style: TextStyle(color: Color(0xFF3B82F6))),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Widget Configuration',
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                initialValue: _widgetName,
                                decoration: const InputDecoration(
                                  labelText: 'Widget Display Title',
                                  labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                                ),
                                style: const TextStyle(color: Colors.white),
                                onChanged: (val) => setState(() => _widgetName = val),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedType,
                                items: ['Bar Chart', 'KPI Summary Metric', 'Data Table List']
                                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                                    .toList(),
                                onChanged: (val) => setState(() => _selectedType = val!),
                                decoration: const InputDecoration(
                                  labelText: 'Visualization Type',
                                  labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                                ),
                                dropdownColor: const Color(0xFF1E293B),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                initialValue: _endpoint,
                                decoration: const InputDecoration(
                                  labelText: 'Data Source REST API Endpoint',
                                  labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                                ),
                                style: const TextStyle(color: Colors.white),
                                onChanged: (val) => setState(() => _endpoint = val),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _size,
                                items: ['Small', 'Medium', 'Large']
                                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                    .toList(),
                                onChanged: (val) => setState(() => _size = val!),
                                decoration: const InputDecoration(
                                  labelText: 'Widget Container Size',
                                  labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                                ),
                                dropdownColor: const Color(0xFF1E293B),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Widget Definition Deployed successfully!')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B82F6),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(50),
                                ),
                                child: const Text('Deploy Custom Widget'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Preview Canvas (Right)
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Live Render Canvas Preview', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              Expanded(
                                child: Center(
                                  child: Container(
                                    width: 380,
                                    height: 260,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E293B),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0xFF334155)),
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _widgetName,
                                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            const Icon(Icons.show_chart_rounded, color: Color(0xFF3B82F6)),
                                          ],
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              'Rendering ${_selectedType}\nConfigured Source: ${_endpoint}\nSize: ${_size}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(color: Color(0xFF64748B), height: 1.5, fontSize: 13),
                                            ),
                                          ),
                                        ),
                                        const Text('Last updated: 1 min ago', style: TextStyle(color: Color(0xFF64748B), fontSize: 10)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
