## Visão Geral

Este projeto é uma Prova de Conceito (POC) de um aplicativo Flutter que carrega, armazena e identifica, mesmo offline, a **Planta Global** (um polígono georreferenciado) em que o usuário se encontra, a partir de sua localização GPS.

---

## Funcionalidades Principais

- **Carga de Plantas**: Faz download (ou leitura de asset) de um JSON com polígonos georreferenciados.
- **Cache Offline**: Persiste todos os polígonos no dispositivo usando Hive.
- **Match de Localização**: Compara a posição atual do usuário contra todos os polígonos para identificar em qual (ou quais) planta(s) ele está.
- **UI Reativa**: Utiliza `ValueNotifier` e `ValueListenableBuilder` para atualizar somente as partes necessárias da interface.
- **Visão em Mapa**: Mostra um mini‐mapa com OpenStreetMap e um marcador na posição atual.
- **Teste de Volumetria**: Duplica em memória a lista de polígonos para simular cenários com grande quantidade de dados.

---

## Estrutura do Projeto

```
lib/
├─ controllers/       # Lógica de negócio e estado (ChangeNotifier + ValueNotifier)
├─ domain/
│  ├─ models/         # Modelos de dados (GlobalPlantModel, PolygonModel)
│  └─ repositories/   # Interfaces de repositório
├─ external/          # Data‐source (ex.: leitura JSON ou API)
├─ presenter/  
│  ├─ controller        
│  └─ page
└─ main.dart

assets/
└─ global_plants.json # JSON com polígonos de teste
```

---

## Fluxo de Carregamento e Match

1. **Ao abrir a tela**:

   - `loadingAll` inicia em `true` e exibe um spinner.
   - Chama `onMatchButtonPressed()`, que:
     1. Executa `loadPlants()` (busca e duplica a lista para testes).
     2. Persiste os dados em cache (`Hive.putAll`).
     3. Pega a localização atual (`Geolocator`).
     4. Executa `matchPlantForCurrentLocation()` (algoritmo de raios) para identificar quais polígonos contêm o ponto.
   - Ao final, `loadingAll` fica `false` e a UI mostra o mapa, coordenadas e resultado do match.

2. **Ao clicar no botão “Localizar Planta”**:

   - Repete apenas o passo de obter localização e match, mantendo os polígonos em cache.

---

## Decisões Técnicas e Motivações

- **Hive (NoSQL)**

  - **Não relacional** e orientado a objetos.
  - Grava e lê `GlobalPlantModel` diretamente, sem SQL.

- **ValueNotifier + ValueListenableBuilder**

  - Atualizações finas de UI sem `setState` em larga escala.
  - Divisão clara: *controller* gerencia dados e estado; *page* monta apenas widgets reativos.

- **Volumetria**

  - Duplica a lista original em memória para simular 10× ou mais o volume.
  - Permite medir tempo de carga e comportamento do cache.

---

## Como Executar

1. **Pré‑requisitos**: Flutter 3.22.0, Dart SDK, Android/iOS emulador ou dispositivo.
2. **Instalar dependências**:
   ```bash
   flutter pub get
   ```
3. **Gerar adapters Hive** (se usar `hive_generator`):
   ```bash
   flutter packages pub run build_runner build
   ```
4. **Executar**:
   ```bash
   flutter run
   ```
