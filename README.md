# 🌍 ORBIS — Monitoramento Climático do Solo

> Plataforma cross-platform de monitoramento de temperatura e umidade do solo, desenvolvida em Flutter com arquitetura MVVM.

---
## 👥 Devs Integrantes

| Nome | RM |
|---|---|
| Anny Pereira | 553793 | 
| Giovanna Makida | 552852 | 
| Katharine Fernandes | 552673 | 

---

## 🎯 Global Solution

A Nova Corrida Espacial propõe o uso de tecnologias espaciais para gerar impacto positivo na sociedade. O ORBIS responde a esse desafio utilizando dados de sensoriamento remoto e APIs de observação da Terra para democratizar o acesso a informações climáticas urbanas.

---

## 📋 Descrição da Solução

O **ORBIS** é uma plataforma de monitoramento climático focada no fenômeno das **ilhas de calor urbanas** — o aumento progressivo da temperatura em áreas urbanas causado pela substituição de vegetação por concreto e asfalto.

A solução integra dados da **API Open-Meteo** para exibir a temperatura do solo em tempo real e apresenta recomendações orientativas ao usuário conforme o nível de calor detectado.

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


## 📸 Telas

| Tela inicial | Resultado da consulta | Detalhes |
|---|---|---|
| Campo de busca com autocomplete | Cards com temperatura, umidade e coordenadas | Dados completos, barra de risco e recomendações |

---
