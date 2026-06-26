import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ThemeService {
  constructor(private prisma: PrismaService) {}

  async getThemeColorsAndTokens(workspaceId: string, applicationId: string) {
    const [theme, tokens] = await Promise.all([
      this.prisma.applicationTheme.findFirst({ where: { workspaceId, applicationId } }),
      this.prisma.designToken.findMany({ where: { workspaceId, applicationId } }),
    ]);

    const themeJson = theme ? JSON.parse(theme.brandingJson) : {};
    const tokensMap = {} as any;
    tokens.forEach((t) => {
      tokensMap[t.tokenName] = { value: t.tokenValue, type: t.tokenType };
    });

    return {
      colors: {
        primary: themeJson.primary || '#0F172A',
        secondary: themeJson.secondary || '#64748B',
        background: themeJson.background || '#0F172A', // Dark Slate matching guidelines
        text: themeJson.text || '#F8FAFC',
      },
      logoUrl: themeJson.logoUrl || '',
      tokens: tokensMap,
    };
  }

  async saveDesignToken(workspaceId: string, applicationId: string, tokenName: string, tokenValue: string, tokenType: string) {
    const existing = await this.prisma.designToken.findFirst({
      where: { workspaceId, applicationId, tokenName },
    });

    if (existing) {
      return this.prisma.designToken.update({
        where: { id: existing.id },
        data: { tokenValue, tokenType },
      });
    }

    return this.prisma.designToken.create({
      data: { workspaceId, applicationId, tokenName, tokenValue, tokenType },
    });
  }
}
