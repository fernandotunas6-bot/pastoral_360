# ⛪ PASTORAL 360 — SISTEMA INTEGRAL DE AVALIAÇÃO PASTORAL E GESTÃO MINISTERIAL

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.19.6-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.3.0-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Supabase-PostgreSQL-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white" alt="Supabase">
  <img src="https://img.shields.io/badge/Material_3-Design_System-6750A4?style=for-the-badge&logo=materialdesign&logoColor=white" alt="Material 3">
  <img src="https://img.shields.io/badge/Precisão_Cálculos-100%25_PASS-10B981?style=for-the-badge" alt="Precisão">
</p>

---

## 📋 Visão Geral do Sistema

O **Pastoral 360** é uma plataforma empresarial de alto desempenho desenvolvida para a **Igreja Adventista do Sétimo Dia — União Sudoeste de Angola — Missão Centro (MCASD 2026)**.

O sistema automatiza a avaliação pastoral, acompanhamento distrital de 330 congregações, relatórios trimestrais ministeriais e integração bidirecional em tempo real com o Excel mestre.

---

## 🌟 Principais Recursos e Módulos

### 📊 1. Painel Executivo (Admin Dashboard)
- Visualização em tempo real de KPIs da Missão (**100 Pastores**, **330 Congregações**, Média Geral **4.52**).
- Consulta Rápida de Pastor por Distrito, Província (Huambo, Bié, Cubango, Quando) e Cargo.
- Gráficos de barras de desempenho por área ministerial (Assistência, Relacionamento, Família, Sermões e Administração).

### 📱 2. Avaliação Pastoral por Telemóvel
- Interface responsiva optimizada para telemóveis e tablets para uso dos Oficiais e Anciãos de Igreja.
- Autenticação e seleção encadeada (*Distrito ➔ Igreja ➔ Pastor*).
- Sliders interativos de pontuação (1.0 a 5.0) com envio automático para o Supabase Cloud e sincronização no Excel.

### 📝 3. Ficha de Avaliação Fiel (51 Critérios)
- Matriz completa dos **51 critérios de avaliação** divididos em 5 áreas ministeriais.
- Ficha de impressão A4 institucional para reuniões de comissão e arquivo físico.

### 🖨️ 4. Relatório Trimestral da Associação Pastoral (28 Itens)
- Módulo digital de preenchimento dos **28 itens de Obreiros e Missão Global Evangelista**.
- Fórmulas automáticas de totais e exportação em formato oficial.

### 📞 5. Directório Telefónico Ministerial
- Lista de contactos telefónicos dos 100 pastores com acção direta de chamada (`tel:`).

---

## 📐 Arquitetura do Sistema (Clean Architecture)

```text
┌─────────────────────────────────────────────────────────────────┐
│                       CAMADA DE APRESENTAÇÃO                    │
│  - Widgets Material 3 (NavigationRail, StatCard, Responsive)    │
│  - State Management com Riverpod NotifierProviders              │
│  - Rotas Declarativas com GoRouter                              │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                        CAMADA DE DOMÍNIO                        │
│  - Entidades Principais (Pastor, Church, Evaluation, Report)    │
│  - Casos de Uso (EvaluatePastor, SyncExcelData, ExportPdf)      │
│  - Contratos de Repositório                                     │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                         CAMADA DE DADOS                         │
│  - Supabase Cloud Data Source (PostgreSQL + RLS)                │
│  - OpenPyXL Local Excel Data Source (Sync Real-time)            │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📁 Estrutura de Pastas do Repositório

```text
pastoral_360/
├── .github/workflows/deploy.yml        # Automação de CI/CD para Flutter Web
├── seed_data/                          # Sementeira JSON de Pastores, Igrejas e Critérios
│   ├── pastores.json
│   ├── churches.json
│   └── criteria.json
├── migrations/
│   └── 001_initial_schema.sql          # Migração SQL DDL PostgreSQL / Supabase
├── docs/                               # Documentação de Arquitetura e Mapeamento
│   ├── ARCHITECTURE.md
│   └── EXCEL_MAPPING.md
├── lib/
│   ├── main.dart                       # Ponto de Entrada da Aplicação
│   ├── core/                           # Temas, Permissões RBAC, Rotas, Provedores
│   └── src/
│       └── features/                   # Módulos Clean Architecture (Dashboard, Pastores, Avaliações)
├── Dockerfile                          # Contentor Docker para Implantação em Nuvem
├── docker-compose.yml                  # Orquestração Docker
├── server.py                           # Servidor Python REST API & Conector Excel
└── expand_excel_services.py            # Servidor de Extração e Validação do Excel
```

---

## 🚀 Como Executar o Projeto

### Opção A: Execução Web / Servidor Local
```bash
# 1. Instalar dependências Python
pip install flask flask-cors openpyxl requests

# 2. Executar o servidor de sincronização
python server.py

# Aceder no navegador do Computador: http://127.0.0.1:5000
# Aceder no Telemóvel (Rede Wi-Fi): http://<SEU_IP_LOCAL>:5000
```

### Opção B: Implantação com Docker
```bash
docker-compose up -d --build
```

---

## 🔐 Segurança e Permissões (RBAC)

O sistema possui controlo granular de acessos configurado para **7 Papéis**:

| Papel | Permissões |
| :--- | :--- |
| `Super Admin` | Acesso total ao sistema, configurações e banco de dados |
| `Presidente` | Leitura global de todas as avaliações e relatórios executivos |
| `Secretário Executivo` | Gestão de pastores, distritos e emissão de relatórios |
| `Tesoureiro` | Acesso a relatórios e dados administrativos |
| `Supervisor` | Acompanhamento de distritos específicos |
| `Pastor Distrital` | Preenchimento do Relatório Trimestral do seu distrito |
| `Oficial da Igreja` | Preenchimento da Avaliação Pastoral por telemóvel |

---

*Desenvolvido e Sistematizado por **Valentino Canguele** | Missão Centro (MCASD 2026)*
