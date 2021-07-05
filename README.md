# GrammaticalEvolution
[![CI](https://github.com/andreina-covi/GrammaticalEvolution/actions/workflows/runTests.yml/badge.svg)](https://github.com/andreina-covi/GrammaticalEvolution/actions/workflows/runTests.yml)

## Installation

Installation by default

```Smalltalk
  Metacello new
 baseline:'GrammaticalEvolution';
 repository: 'github://andreina-covi/GrammaticalEvolution:master/src';
 load
```

Installation with visualization

```Smalltalk
  Metacello new
 baseline:'GrammaticalEvolution';
 repository: 'github://andreina-covi/GrammaticalEvolution:master/src';
 load: #('all')
```

----
## Example:

```Smalltalk
| a |
a := GEAssertion new seed: 245.
a  testClasses:  {RSColoredTreePaletteTest};
    targetClass: RSColoredTreePalette;
    targetSelectors: #(#allLeavesAccessibleFrom:);
    packageScope: 'Roassal3*';
    folderToExport: '/tmp'.
a run.
a.
```

To visualize the evolution type the following: 

```Smalltalk
GAEvoViz new
    populations: ((self allPopulations at: #allLeavesAccessibleFrom: ) collect: #population); 
    populationFileName: '/tmp/RSColoredTreePalette_allLeavesAccessibleFrom_Data.csv';
    comparisonSelector: #<;
    run.
```

You need to specify:

- populations through generations,
- .csv file location where the result was exported, and 
- like the goal is the decreasing of fitness value we need to specify the `comparisonSelector:` with `#<`
