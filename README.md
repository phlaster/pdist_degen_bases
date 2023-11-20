# Calculating pdistance between sequences with degenerated bases

[base degeneracy codes](https://eu.idtdna.com/pages/products/custom-dna-rna/mixed-bases):

## 2-base:
|code|bases|
|-|-|
R | A,G 
Y | C,T 
M | A,C 
K | G,T 
S | C,G
W | A,T

## pdist coefficients:
|-|R|Y|M|K|S|W|
|-|-|-|-|-|-|-|
|R|2|0|0.5|0.5|0.5|0.5|
|Y|0|2|0.5|0.5|0.5|0.5|
|M|0.5|0.5|2|0|0.5|0.5|
|K|0.5|0.5|0|2|0.5|0.5|
|S|0.5|0.5|0.5|0.5|2|0|
|W|0.5|0.5|0.5|0.5|0|2|


## \>2-base:
|code|bases|
|-|-|
H | A,C,T 
B | C,G,T 
V | A,C,G 
D | A,G,T 
N | A,C,G,T

