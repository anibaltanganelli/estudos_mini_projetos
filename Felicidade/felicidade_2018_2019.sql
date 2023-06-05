#1. Sobre evolução geral, como foi a evolução global do ranking de felicidade entre 2018 2 2019 levando em consideração a posição de cada país.
SELECT
O.Country_or_region AS Pais,
O.Overall_rank AS posicao_2018,
N.Overall_rank AS posicao_2019,
(O.Overall_rank - N.Overall_rank) AS evolucao
FROM `felicidade.2018` O
INNER JOIN `felicidade.2019` N
ON O.Country_or_region = N.Country_or_region
GROUP BY O.Country_or_region, O.Overall_rank, N.Overall_rank
ORDER BY Posicao_2019 ASC;

#1.1 Qual o top 20 de países mais felizes nos dois anos?
SELECT
O. Country_or_region Pais,
N.Overall_rank Ranking_2019,
O.Overall_rank Ranking_2018
FROM `felicidade.2018` O
INNER JOIN `felicidade.2019` N
ON O.Country_or_region = N.Country_or_region
GROUP BY O.Country_or_region,O.Overall_rank, N.Overall_rank
ORDER BY N.Overall_rank ASC
LIMIT 20;

#1.2 Quais os 20 países menos felizes nos dois anos?
SELECT
O. Country_or_region Pais,
N.Overall_rank Ranking_2019,
O.Overall_rank Ranking_2018
FROM `felicidade.2018` O
INNER JOIN `felicidade.2019` N
ON O.Country_or_region = N.Country_or_region
GROUP BY O.Country_or_region,O.Overall_rank, N.Overall_rank
ORDER BY N.Overall_rank DESC
LIMIT 20;

#1.2 Qual país teve a maior evolução no ranking?
SELECT
O.Country_or_region AS Pais,
O.Overall_rank AS posicao_2018,
N.Overall_rank AS posicao_2019,
(O.Overall_rank - N.Overall_rank) AS evolucao
FROM `felicidade.2018` O
INNER JOIN `felicidade.2019` N
ON O.Country_or_region = N.Country_or_region
GROUP BY O.Country_or_region, O.Overall_rank, N.Overall_rank
ORDER BY evolucao DESC
LIMIT 1;

#1.3 Qual país sofreu a maior queda no ranking?
SELECT
O.Country_or_region AS Pais,
O.Overall_rank AS posicao_2018,
N.Overall_rank AS posicao_2019,
(O.Overall_rank - N.Overall_rank) AS evolucao
FROM `felicidade.2018` O
INNER JOIN `felicidade.2019` N
ON O.Country_or_region = N.Country_or_region
GROUP BY O.Country_or_region, O.Overall_rank, N.Overall_rank
ORDER BY evolucao ASC
LIMIT 1;

#2. Sobre do Score, como foi a evolução global do ranking de felicidade entre 2018 e 2019?.
SELECT
O.Country_or_region AS Pais,
O.Score AS pontuacao_2018,
N.Score AS pontuacao_2019,
(N.Score - O.Score) AS evolucao_pontuacao
FROM `felicidade.2018` O
INNER JOIN `felicidade.2019` N
ON O.Country_or_region = N.Country_or_region
GROUP BY O.Country_or_region, O.score, N.score
ORDER BY evolucao_pontuacao ASC;

#2.1 Considerando os cinco países com maior evolucao no score, como foi a evolução de cada um dos fatores de um ano para o outro Para cada país? 
SELECT 
O.Country_or_region Pais,
N.Overall_rank - O.Overall_rank ranking,
ROUND(N.Score - O.Score, 5) score,
ROUND(N.GDP_per_capita, 5) - O.GDP_per_capita GDP,
ROUND(N.Social_support - O.Social_support,5) Suporte_soc,
ROUND(N.Healthy_life_expectancy - O.Healthy_life_expectancy, 5) expectativa_vida,
ROUND(N.Freedom_to_make_life_choices - O.Freedom_to_make_life_choices, 5) liberdade,
ROUND(O.Generosity - O.Generosity, 5) generosidade,
ROUND(N.Perceptions_of_corruption - O.Perceptions_of_corruption, 5) corrupcao
FROM `felicidade.2018` O
INNER JOIN `felicidade.2019` N
ON O.Country_or_region = N.Country_or_region
GROUP BY Pais, ranking,Score, GDP, Suporte_soc, expectativa_vida, liberdade, generosidade, corrupcao
ORDER BY score ASC; 

# 3. Considerando o ranking e as pontuações. Como se comportou cada um dos fatores levando em consideração os cinco primeiros e os cinco últimos calssificados do ano de 2019?

SELECT 
COUNT(Country_or_region)
FROM `felicidade.2019`;

SELECT 
O.Country_or_region Pais,
N.Overall_rank as ranking_2019,
N.Overall_rank - O.Overall_rank evolucao_ranking,
ROUND(N.Score - O.Score, 5) score,
ROUND(N.GDP_per_capita, 5) - O.GDP_per_capita GDP,
ROUND(N.Social_support - O.Social_support,5) Suporte_soc,
ROUND(N.Healthy_life_expectancy - O.Healthy_life_expectancy, 5) expectativa_vida,
ROUND(N.Freedom_to_make_life_choices - O.Freedom_to_make_life_choices, 5) liberdade,
ROUND(O.Generosity - O.Generosity, 5) generosidade,
ROUND(N.Perceptions_of_corruption - O.Perceptions_of_corruption, 5) corrupcao
FROM `felicidade.2018` O
INNER JOIN `felicidade.2019` N
ON O.Country_or_region = N.Country_or_region
WHERE N.Overall_rank >= 1 AND N.Overall_rank <= 5 OR N.Overall_rank >= 152 AND N.Overall_rank <= 156
GROUP BY Pais, ranking_2019, ranking_2019, evolucao_ranking, Score, GDP, Suporte_soc, expectativa_vida, liberdade, generosidade, corrupcao
ORDER BY N.Overall_rank; 

#3.1 Qual a evolucao dos indices nos paises que tiveram maior e menor crescimento do score?
SELECT 
O.Country_or_region Pais,
N.Overall_rank as ranking_2019,
N.Overall_rank - O.Overall_rank evolucao_ranking,
ROUND(N.Score - O.Score, 5) score,
ROUND(N.GDP_per_capita, 5) - O.GDP_per_capita GDP,
ROUND(N.Social_support - O.Social_support,5) Suporte_soc,
ROUND(N.Healthy_life_expectancy - O.Healthy_life_expectancy, 5) expectativa_vida,
ROUND(N.Freedom_to_make_life_choices - O.Freedom_to_make_life_choices, 5) liberdade,
ROUND(O.Generosity - O.Generosity, 5) generosidade,
ROUND(N.Perceptions_of_corruption - O.Perceptions_of_corruption, 5) corrupcao
FROM `felicidade.2018` O
INNER JOIN `felicidade.2019` N
ON O.Country_or_region = N.Country_or_region
GROUP BY Pais, ranking_2019, evolucao_ranking, Score, GDP, Suporte_soc, expectativa_vida, liberdade, generosidade, corrupcao
HAVING score <= -0.197 AND Score >= -0.983 OR score <= .87 AND score >= 0.284
ORDER BY Score ASC;

##ESTUDOS GERAIS BRASIL
#Generosidade Brasil

SELECT
Country_or_region,
Generosity
FROM `felicidade.2019`
WHERE Country_or_region = 'Brazil'
GROUP BY Country_or_region, Generosity;

#Evolução ranking_geral Brasil 2018 e 2019
SELECT
A18.Country_or_region AS PAIS,
A18.Overall_rank AS Rank_2018,
A19.Overall_rank AS Rank_2019,
A19.Overall_rank - A18.Overall_rank AS evolucao
FROM felicidade.2018 AS A18
INNER JOIN felicidade.2019 AS A19
ON A18.Country_or_region = A19.Country_or_region
WHERE A18.Country_or_region = 'Brazil';

#Evolução todos os critérios Brasil
SELECT
A18.Country_or_region,
A19.Overall_rank - A18.Overall_rank AS ranking_geral, 
A19.Score - A18.Score AS pontuacao,
A19.GDP_per_capita - A18.GDP_per_capita AS gdp,
A19.Social_support - A18.Social_support AS suporte_social, 
A19.Healthy_life_expectancy - A18.Healthy_life_expectancy AS expectativa_vida,
A19.Freedom_to_make_life_choices - A18.Freedom_to_make_life_choices AS liberdade_escolhas,
A19.Generosity - A18.Generosity AS generosidade,
A19.Perceptions_of_corruption - A18.Perceptions_of_corruption AS percepcao_corrupcao
FROM felicidade.2018 AS A18
INNER JOIN felicidade.2019 AS A19
ON A18.Country_or_region = A19.Country_or_region
WHERE A18.Country_or_region = 'Brazil';

##Nível brasileiro atual de social support é comparável a qual país do ano anterior?
SELECT 
A.Country_or_region, A.Social_support, B.Country_or_region, B.Social_support
FROM `felicidade.2019` A, `felicidade.2018` B
WHERE A.Social_support = B.Social_support AND A.Country_or_region = 'Brazil';
