# Algebra relacional

A Algebra Relacional, que a partir de agora chamarei de AR, é uma linguagem formal orientada a conjuntos utilizada para se manipular um modelo relacional. É com ela que os bancos de dados trabalham por trás dos panos.

## Operações

Existem diversas classes de operações que podem ser representadas com AR, dentre elas:

- Fundamentais:
    - Unárias: seleção, projeção
    - Binárias: produto cartesiano, união, diferença
- Derivadas:
    - Binárias: intersecção, junção, divisão
- Especiais: renomeação e atribuição

### Seleção

Retorna as tuplas de uma tabela que satisfazem um predicado, tendo então como resultado um subconjunto dessa tabela.

A sintaxe utiliza a letra grega 𝛔 (sigma) minúscula, tendo como notação completa:

```
𝛔 predicados (tabela)
```

Os predicados podem operar sobre quaisquer campos da tabela, utilizando os seguintes comparadores `= < <= > >= ≠` e os operadores lógicos `˄ (and) ˅ (or) ¬ (not)`.

Utilizando o [esquema do hospital](./exemplo-esquema#esquema-hospital) vamos fazer algumas operações de seleção.

1. Selecionando todos os pacientes com sarampo

`𝛔 doença = 'sarampo' (pacientes)`

2. Selecionando todos os médicos especialistas em 'ortopedia' e maiores de 55 anos

`𝛔 especialidade = 'ortopedia' ˄ idade > 55 (medicos)`

3. Selecionando todas as consultas, exceto aquelas marcadas para os médicos com código 46 e 79

`𝛔 id_medico != 46 ˄ id_medico != 79 (consultas)`

4. Buscar ambulatórios do quarto andar, com id superior a 10 e capacidade superior a 50

`𝛔 id_ambulatorio > 10 ˄ andar = 4 ˄ capacidade > 50 (ambulatorios)`

### Projeção

Opera sobre uma tabela, selecionando um ou mais atributos de interesse e retornando um subconjunto vertical da tabela.

A sintaxe utiliza a letra grega π (pi), tendo como notação completa:

```
π lista de atributos (tabela)
```

1. Buscar o nome e especialidade de todos os médicos

`π nome, especialidade (medicos)`

2. Buscar o número dos ambulatórios do terceiro andar

`π numero (𝛔 andar = 4 (ambulatorios))`

3. Buscar o código dos médicos e a data das consultas para os pacientes com código 122 e 725

`π id_medico, data (𝛔 id_paciente = 122 ˄ id_paciente = 725 (consultas))`

4. Buscar os números dos ambulatórios com capacidade superior a 50. Estes ambulatórios não podem estar nem no 2o andar nem no 4o andar.

`π id_ambulatorio (𝛔 andar != 2 ˄ andar != 4 ˄ capacidade > 50 (ambulatorios))`

### Produto cartesiano

Opera sobre duas tabelas, produzindo como resultado a combinação de todas as tuplas contidas nos operandos. O grau do resultado é a soma do grau dos operandos e a cardinalidade do resultado é a multiplicação das cardinalidades dos operandos.

A sintaxe utilizada para o produto cartesiano é `tabela1 X tabela2`.

Como exemplo, vamos buscar o nome dos médicos que possuem alguma consulta marcada, tal como a data das suas consultas. Essa busca vai exigir as 3 operações citadas até o momento. Portanto, vamos fazer ela em partes.

1. Primeiro, fazemos a combinação de todos os médicos com todas as consultas usando o produto cartesiano

`medicos X consultas`

2. Depois, selecionamos apenas as tuplas geradas onde o campo `medicos.id_medico` for igual ao campo `consultas.id_medico`. Lembrando de operar em cima do produto cartesiano que fizemos antes.

`𝛔 medicos.id_medico = consultas.id_medico (medicos X consultas)`

3. Por último, aplicamos uma projeção para retornar apenas os campos solicitados, nesse caso o nome do médico e a data da consulta.

`π consultas.data, medicos.nome (𝛔 medicos.id_medico = consultas.id_medico (medicos X consultas))`

### Atribuição

Você percebeu que antes nossa consulta começou a ficar beeem grande né? E daqui pra frente elas tendem a ficar maiores, por isso, a operação de atribuição é tão importante. Essa operação nos permite salvar em uma variável o resultado de uma consulta, fazendo com que a gente consiga quebrar qualquer consulta em etapas.

A notação utilizada é `variavel <- expressao_algebrica`.

Para exemplificar, vamos quebrar aquele exemplo de cima em 3 variáveis:

```
T1 <- π id_medico, data (consultas)
T2 <- π id_medico, nome (medicos)
Resposta <- π nome, data (𝛔 T1.id_medico = T2.id_medico (T1 X T2))
```

### Renomeação

A operação de renomeação altera o nome de atributos ou de tabelas (pra quem já conhece SQL, pense na construção "AS" que te permite dar um apelido para um campo ou tabela). Isso costuma ser útil pra evitar conflitos entre nomes ou para alterar a apresentação de um resultado final.

A sintaxe utilizada é `ρ (atributo1, atributo2, ..., atributoN) E/OU tabela (tabela)`

### União, diferença e intersecção

Essas 3 são operações especiais, primeiramente elas operam apenas sobre duas tabelas (T1 e T2) que possuam compatibilidade, as regras para isso são:

- T1 e T2 possuam o mesmo grau
- Para i até grau(T1): `domínio(atributo Ai de T1)` = `domínio(atributo Ai de T2)`
- O grau do resultado é o grau de T1 e T2
- O nome dos atributos do resultado é sempre definido pela tabela a esquerda, esse caso T1

#### União

Retorna a união de conjuntos entre as tuplas das duas tabelas, eliminando duplicatas (afinal, é um conjunto). A sintaxe é `T1 ∪ T2`.

#### Diferença

Retorna as tuplas presentes em T1 mas ausentes em T2. A sintaxe é `T1 - T2`.

#### Intersecção

Retorna as tuplas que são comuns as duas tabelas, ou seja, uma intersecção. A sintaxe é `T1 ∩ T2`.

### Exercícios sobre união, diferença e intersecção

1. Buscar o nome e CPF dos médicos e dos pacientes cadastrados no hospital.

```
T1 = π nome, cpf (medicos)
T2 = π nome, cpf (pacientes)
Resposta = T1 ∪ T2 
```

2. Buscar o nome, CPF e idade dos médicos, pacientes e funcionários que residem em Florianópolis.

```
T1 = π nome, cpf, idade (𝛔 cidade = "Florianópolis" (medicos))
T2 = π nome, cpf, idade (𝛔 cidade = "Florianópolis" (pacientes))
T3 = π nome, cpf, idade (𝛔 cidade = "Florianópolis" (funcionarios))
Resposta = T1 ∪ T2 ∪ T3
```

### Junção (join)

Retorna uma combinação de tuplas em duas tabelas T1 e T2, sendo que as tuplas devem satisfazer um predicado. Uma junção sem predicado é um produto cartesiano. A sintaxe utiliza um símbolo muito estranho que o professor não colocou como caractere no slide, que eu vou substituir escrevendo "join" por extenso. Dessa forma, teriamos T1 join predicado T2.

Existe ainda um outro subtipo de junção, a junção natural, a definição diz que uma junção natural é uma junção onde o predicado na verdade é uma igualdade entre um ou mais atributos de mesmo nome, por exemplo `T1 join T1.id = T2.id T2`. Quando temos uma junção natural, podemos simplesmente escrever `T1 join T2`. 

### Junções externas (outer joins)

As junções externas são tipos de junções onde as tuplas de uma ou mais tabelas que NÃO forem relacionadas na junção serão mesmo assim mantidas no resultado final. Eu vou usar diagramas de Euler-Venn pra representar o resultado final dessas operações, assim podemos visualizar melhor o que estamos fazendo.

1. **Left outer join**

Nesse caso, todas as tuplas da tabela a esquerda serão mantidas.

![Left outer join](./images/left_outer_join.png)

2. **Right outer join**

Nesse caso, todas as tuplas da tabela a direita serão mantidas.

![right outer join](./images/right_outer_join.png)

2. **Full outer join**

Nesse caso, todas as tuplas das duas tabelas serão mantidas.

![full outer join](./images/full_outer_join.png)