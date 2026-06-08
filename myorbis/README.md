# 🌍 ORBIS — Monitoramento Climático do Solo

> Plataforma cross-platform de monitoramento de temperatura e umidade do solo, desenvolvida em Flutter com arquitetura MVVM.

---

## 📱 Sobre o projeto

O **ORBIS** é uma aplicação Flutter que permite consultar em tempo real a **temperatura e umidade do solo** de qualquer localização do mundo, integrando-se à API gratuita do [Open-Meteo](https://open-meteo.com/).

O projeto está alinhado com as **ODSs da ONU**:
- 🏙️ **ODS 11** — Cidades e Comunidades Sustentáveis
- 🌡️ **ODS 13** — Ação Contra a Mudança Global do Clima

---

## ✨ Funcionalidades

- 🔍 **Busca de cidades** com autocomplete em tempo real
- 🌡️ **Temperatura do solo** com nível de risco (Normal / Moderado / Alerta / Crítico)
- 💧 **Umidade do solo** atual
- 📋 **Tela de detalhes** com barra de risco e recomendações personalizadas
- ⭐ **Favoritos** — salva locais para consulta rápida (persistência local)
- 🔄 **Atualização** dos dados a qualquer momento
- ✅ Tratamento de todos os estados: idle, carregando, sucesso e erro

---

## 🖥️ Plataformas suportadas

| Plataforma | Suporte |
|---|---|
| Chrome Web | ✅ |
| Windows | ✅ |

---

## 🏗️ Arquitetura

O projeto segue o padrão **MVVM (Model-View-ViewModel)** com injeção de dependência via `get_it`.

```
lib/
├── core/
│   └── dependency_injections.dart   # Registro de dependências com get_it
├── data/
│   ├── repositories/
│   │   └── location_repository.dart # Acesso às APIs e persistência local
│   └── services/
│       ├── geocoding_service.dart   # Comunicação com a API de geocoding
│       └── soil_service.dart        # Comunicação com a API de dados do solo
├── domain/
│   └── models/
│       ├── location_model.dart      # Modelo de localização
│       └── soil_data_model.dart     # Modelo de dados climáticos do solo
├── presentation/
│   ├── view_models/
│   │   ├── home_view_model.dart     # Lógica e estado da tela Home
│   │   └── details_view_model.dart  # Lógica e estado da tela de Detalhes
│   ├── home_screen.dart             # Tela principal
│   └── details_screen.dart         # Tela de detalhes
└── main.dart                        # Ponto de entrada do app
```

### Fluxo de dados

```
HomeScreen → HomeViewModel → LocationRepository → GeocodingService / SoilService
                                                → SharedPreferences (favoritos)
```

---

## 🔌 APIs utilizadas

| API | Endpoint | Uso |
|---|---|---|
| Open-Meteo Geocoding | `geocoding-api.open-meteo.com/v1/search` | Busca de cidades pelo nome |
| Open-Meteo Forecast | `api.open-meteo.com/v1/forecast` | Temperatura e umidade do solo |

> Ambas as APIs são **gratuitas** e **não exigem chave de autenticação**.

---

## 📦 Dependências

```yaml
provider: ^6.1.2          # Gerenciamento de estado
get_it: ^7.6.7             # Injeção de dependência
http: ^1.2.1               # Requisições HTTP
shared_preferences: ^2.2.3 # Persistência local
```

---

## 🚀 Como rodar

### Pré-requisitos
- Flutter SDK `>=3.0.0`
- Google Chrome (para web) ou Visual Studio com C++ (para Windows)

### Instalação

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/orbis.git
cd orbis

# Instale as dependências
flutter pub get
```

### Executar

```bash
# Chrome Web
flutter run -d chrome

# Windows
flutter run -d windows

# Se ocorrer erro de CORS no Chrome (apenas em desenvolvimento)
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

### Build para produção

```bash
# Web
flutter build web

# Windows
flutter build windows
```

---

## 📸 Telas

| Tela inicial | Resultado da consulta | Detalhes |
|---|---|---|
| Campo de busca com autocomplete | Cards com temperatura, umidade e coordenadas | Dados completos, barra de risco e recomendações |

---

## 🎓 Contexto acadêmico

Projeto desenvolvido para a **Global Solution** da disciplina de **Desenvolvimento Cross Platform** — FIAP.

**Tema:** Indústria Espacial  
**Solução:** Monitoramento climático acessível para populações urbanas e periféricas

---

## 👥 Público-alvo

- Moradores de áreas urbanas e periferias
- Comunidades interessadas em indicadores ambientais
- Líderes comunitários e gestores públicos
