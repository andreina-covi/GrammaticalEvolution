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
    populations: (self allPopulations at: #allLeavesAccessibleFrom:); 
    populationFileName: '/tmp/RSColoredTreePalette_allLeavesAccessibleFrom_Data.csv';
    comparisonSelector: #<;
    run.
```

You need to specify:

- populations through generations,
- .csv file location where the result was exported, and 
- like the goal is the decreasing of fitness value we need to specify the `comparisonSelector:` with `#<`


Two files will be exported at the final of execution, the first one is to visualize with GAEvoViz tool and the another one is to give information about:

- the rules that have been used in the initial population
- invalid individuals created in the initial population
- invalid individuals created on mutation
- invalid individuals created on crossover
- best fitness achieved in the final generation
- number of generations

With this information we can also compare different grammars for the same problem and export the comparison on a .csv file typing:

```Smalltalk
GEGrammarEvolution exportComparisonOf: #('/tmp/G1.csv' '/tmp/G2.csv' '/tmp/G3.csv' ) to: '/tmp/comparisonGrammars.csv'.
```
