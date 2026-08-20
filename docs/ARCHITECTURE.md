# 📐 PASTORAL 360 - ESPECIFICAÇÃO TÉCNICA DE ARQUITETURA E DESIGN

> **Autor & Engenharia**: Valentino Canguele  
> **Instituição**: Igreja Adventista do Sétimo Dia — União Sudoeste de Angola — Missão Centro (MCASD 2026)

---

## 1. Camadas da Arquitetura (Clean Architecture)

```text
                       ┌──────────────────────────────────────────┐
                       │        CAMADA DE APRESENTAÇÃO            │
                       │  - Componentes Flutter Material 3 UI     │
                       │  - AdminDashboardPage, PastorProfilePage │
                       │  - EvaluationFormPage, QuarterlyReport   │
                       │  - Riverpod NotifierProviders            │
                       └──────────────────────────────────────────┘
                                            │
                                            ▼
                       ┌──────────────────────────────────────────┐
                       │           CAMADA DE DOMÍNIO              │
                       │  - Entidades (Pastor, Church, Evaluation) │
                       │  - Casos de Uso (EvaluatePastor, Import) │
                       │  - Contratos de Repositório              │
                       └──────────────────────────────────────────┘
                                            │
                                            ▼
                       ┌──────────────────────────────────────────┐
                       │            CAMADA DE DADOS               │
                       │  - Supabase Cloud Remote Data Source     │
                       │  - OpenPyXL Local Excel Data Source      │
                       │  - Data Import Center (Staging Engine)   │
                       └──────────────────────────────────────────┘
```

---

## 2. Princípios de Design e Padronização

1. **Base Visual**: Design System baseado em **Material 3** da Google (Modo Escuro e Claro, Pílulas de Navegação, Cartões com Elevação).
2. **Layout Administrativo**: Dashboard responsivo com navegação adaptativa `NavigationRail`, cartões de KPIs, tabelas filtráveis e barras de desempenho.
3. **Organização de Código**: Separação rigorosa de responsabilidades dividida em `Data`, `Domain` e `Presentation`.
