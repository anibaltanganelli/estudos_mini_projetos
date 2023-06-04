## Consultas básicas ##
SELECT * FROM `portugal_proprieties.pt_propri`;
#1- Selcionar os imóveis mais baratos com dois quartos ou menos, sua área e que estejam para locação do Database . 
SELECT
Location,
Rooms,
Area,
Price
FROM `portugal_proprieties.pt_propri`
WHERE AdsType = 'Rent' AND Price IS NOT null AND Rooms <='2'
GROUP BY Location, Rooms, Price, Area
ORDER BY Price , Area;

#2- Fazer um levantamento do M2 das casas a venda em lisboa
SELECT 
location,
area,
price,
price/area AS preco_por_metro
FROM `portugal_proprieties.pt_propri`
WHERE location LIKE "%Lisboa%" AND AdsType = 'Sell' AND area IS NOT NULL AND price IS NOT NULL
GROUP BY location, area, price, preco_por_metro
ORDER BY preco_por_metro ASC;

#3- Para o mesmo tipo de imóvel, qual a região mais barata para morar de aluguel em Lisboa?
SELECT 
location,
Rooms, 
AdsType,
Price
FROM `portugal_proprieties.pt_propri`
WHERE price IS NOT NULL AND Rooms = '2' AND AdsType = 'Rent' AND location Like '%Lisboa%'
GROUP BY location, price, Rooms, AdsType
Order By price;

#4- Selecionar todas as propriedades da região de Viseu
SELECT *
FROM `portugal_proprieties.pt_propri`
WHERE location LIKE '%Viseu%';

#5- Calcular a média de preços de aluguél na região de viseu que possuam dois quartos
SELECT
AVG(Price) AS media_preco,
FROM `portugal_proprieties.pt_propri`
WHERE Rooms = '2' AND location LIKE '%Viseu%' AND AdsType = 'Rent';

#6- Comparar a média de preços dos imóveis com 2 quartos para aluguém de Viseu com os de Lisboa
SELECT
AVG(Price) AS media_preco_Viseu,
(
  SELECT
  AVG(price) 
  FROM `portugal_proprieties.pt_propri`
  WHERE Rooms = '2' AND location LIKE '%Lisboa%' AND AdsType = 'Rent'
) AS media_preco_lisboa
FROM `portugal_proprieties.pt_propri`
WHERE Rooms = '2' AND location LIKE '%Viseu%' AND AdsType = 'Rent';

##PERGUNTAS DE NEGÓCIOS - CORRETOR DE IMÓVEIS FAZENDO CONSULTAS PARA CLIENTES ##

#1-  Um casal pretende comprar uma casa de 3 a 4 dormitórios em Lisboa e possui 125000 mil euros. No entanto, eles pretendem alugar um imóvel de 2 quartos por 3 meses enquanto pesquisa por essa casa. O valor total do gasto com aluguel no trimestre deve ficar entre 3 e 4 mil euros e esse valor será descontado dos 125000.
SELECT 
location,
Rooms,
AdsType,
price
FROM `portugal_proprieties.pt_propri`
WHERE price Between 1000 AND 1333.33 AND price IS NOT NULL AND location LIKE '%Lisboa%'
AND AdsType = 'Rent' AND Rooms = '2'
UNION DISTINCT
SELECT
location,
Rooms,
AdsType,
price
FROM `portugal_proprieties.pt_propri`
WHERE price <= 121000 - 4000 AND price IS NOT NULL AND location LIKE '%Lisboa%' AND AdsType = 'Sell' AND Rooms BETWEEN '3' AND '4';

#1.1- O casal decidiu que prefere alugar no mesmo bairro em que vão comprar. Também decidiram que pretendem buscar uma casa entre de 90000 e 125000 de dois a três quartos. As demais características seguem as citadas acima. (OBS em função dos imóveis não possuirem id, não é possível afirmar se os imóveis para locação ou compra sejam os mesmos.)
SELECT
R.location,
R.price as Preco_aluguel,
R.Rooms,
R.ProprietyType,
S.price as Preco_venda
FROM `portugal_proprieties.pt_propri`R
JOIN `portugal_proprieties.pt_propri`S
ON R.location = S.location
WHERE R.price IS NOT NULL AND S.price IS NOT NULL AND R.location Like '%Lisboa%' AND S.location LIKE "%Lisboa%"
AND R.price > 400 AND R.price< 1333 AND S.price >= 90000 AND S.price <= 121000 AND R.rooms BETWEEN '2' AND '3' AND S.rooms BETWEEN '2' AND '3'
GROUP BY R.location, R.price, R.Rooms,R.ProprietyType, S.price
ORDER BY R.price, S.price;

#1.2- Verificando a igualdade das informações verificando assim a possibilidade de o mesmo imóvel estar disponível tanto para venda quanto para locação. Antes será feita a contagem dos itens para ver onde há divergência (para eliminar da busca)
SELECT
COUNT(R.location) regiao,
COUNT(R.price) Preco_aluguel,
COUNT(R.Rooms) n_quartos1,
COUNT(R.Area) area1,
COUNT(R.Bathrooms) banheiros1,
COUNT(R.Condition) condicao1,
COUNT(R.ProprietyType) tipo1,
COUNT(S.location) regiao2,
COUNT(S.price) Preco_venda,
COUNT(S.Rooms) n_quartos2,
COUNT(S.Area) area_2,
COUNT(S.Bathrooms) banheiros2,
COUNT(S.Condition) condicao2,
COUNT(S.ProprietyType) tipo2,
FROM `portugal_proprieties.pt_propri`R
JOIN `portugal_proprieties.pt_propri`S
ON R.location = S.location
WHERE R.price IS NOT NULL AND S.price IS NOT NULL AND R.location Like '%Lisboa%' AND S.location LIKE "%Lisboa%"
AND R.price > 400 AND R.price < 1333 AND S.price >= 90000 AND S.price <= 121000 AND R.rooms BETWEEN '2' AND '3' AND S.rooms BETWEEN '2' AND '3';

#1.3- Existe ausência de resultados na condição e nos banheiros. Portanto, serão retirados da busca.
SELECT
R.location,
R.price as Preco_aluguel,
R.Rooms,
R.Area,
R.ProprietyType,
S.Rooms,
S.Area,
S.price as Preco_venda
FROM `portugal_proprieties.pt_propri`R
JOIN `portugal_proprieties.pt_propri`S
ON R.location = S.location
WHERE R.price IS NOT NULL AND S.price IS NOT NULL AND R.location Like '%Lisboa%' AND S.location LIKE "%Lisboa%"
AND R.price > 400 AND R.price < 1333 AND S.price >= 90000 AND S.price <= 121000 AND R.rooms BETWEEN '2' AND '3' AND S.rooms BETWEEN '2' AND '3' AND R.Rooms = S.Rooms AND R.Area = S.Area AND R.ProprietyType = S.ProprietyType
GROUP BY R.location, R.price, R.Rooms, R.Area, R.ProprietyType,S.Rooms, S.Area, S.price;
#De todos os imóveis disponíveis dentro das condições solicitadas, apenas dois apartamentos parecem estar disponíveis para aluguel ou compra.

#2- Uma família pretende se mudar para Viseu e buscam uma casa que custe entre 200 a 250 mil, que possua 4 quartos e pelo menos dois banheiros. Para facilitar a busca, criaremos um id.
SELECT
CONCAT(Area, LEFT(Location, 5)) AS ID_casa,
location,
Rooms,
Bathrooms,
price
FROM `portugal_proprieties.pt_propri`
WHERE location LIKE '%Viseu%' AND Rooms = '4' AND Bathrooms >= 2 AND price BETWEEN 200000 AND 250000 AND AdsType = 'Sell' 
GROUP BY Area,location, Rooms, Bathrooms, price
ORDER BY price;

#3- Uma pessoa quer comprar uma casa que renda ao menos entre 0,5% e 1% ao mês na região de Porto. Sabendo que ela possuí 120 mil euros para investir e ela pretende gastar todo o valor e acredita que o imóvel é mais atrativo quado o valor está acima dos 100 mil euros. Ela não pretende fazer reformas.

#3.1- conhecendo características gerais
SELECT 
*
FROM `portugal_proprieties.pt_propri`
WHERE price BETWEEN (120000 * 0.005) AND (120000 * 0.01) AND location LIKE '%Porto%' AND AdsType = 'Rent';

#3.2- calculando médias para apartamentos
## Obs em pesquisa feita em sites de imobiliárias, verificou-se que o custo de condomínio fica em torno de 50,00/mês. Em outra pesquisa verificou-se que em geral, esse custo é do proprietário, não havendo uma regra específica.
SELECT
AVG(PARSE_BIGNUMERIC(Rooms)) AS quartos,
AVG(Price) media_preco,
AVG(area) media_area,
FROM `portugal_proprieties.pt_propri`
WHERE price BETWEEN (120000 * 0.005)-50 AND (120000 * 0.01)-50 AND location LIKE '%Porto%' AND ProprietyType = 'Apartment';
# A pesquisa aponta que os apartamentos que renderiam o valor esperado possuem mais de um quarto e têm area à partir de 76 metros. 

#3.3- Buscando apartamentos com area acima de 76 metros e 2 quartos para compra. 
SELECT *
FROM `portugal_proprieties.pt_propri`
WHERE Price IS NOT NULL AND Price BETWEEN 100000 AND 120000 AND Location Like '%Porto%' AND area > 76 AND Rooms > "2" AND ProprietyType = 'Apartment' AND Condition <> 'To recovery'
ORDER BY Price ASC;
# A pesquisa retornou 17 imóveis

#3.4- Calculando métricas para casas 
SELECT
AVG(PARSE_BIGNUMERIC(Rooms)) AS quartos,
AVG(Price) media_preco,
AVG(area) media_area,
FROM `portugal_proprieties.pt_propri`
WHERE price BETWEEN (120000 * 0.005) AND (120000 * 0.01) AND location LIKE '%Porto%' AND ProprietyType = 'House';
# A pesquisa identificou que as casas alugadas dentro do intervalo possuem mais de dois quartos e área superior a 116 metros.

#3.5- Buscando casas com mais de 2 quartos e mais de 116 metros.
SELECT * 
FROM `portugal_proprieties.pt_propri`
WHERE Price IS NOT NULL AND PRICE BETWEEN 100000 AND 120000 AND Condition <> 'To recovery' AND area > 116 AND Rooms > '2' AND location LIKE "%Porto%" AND ProprietyType = 'House'
ORDER BY Price ASC;
# A busca retornou 12 imóveis.

# Orientações para a cliente: 
# - Se informar sobre o histórico de ocupação do imóvel que ela escolher e seu entorno; 
# - No caso de apartamento, levar em conta o custo de condomínio pela média de desocupação; 
# - Verificar estado do imóvel para avaliar custos de curto e médio prazo de manutenção;
# - Buscar informações sobre possíveis investimentos públicos na área que possam valorizar o imóvel;
# - Optar por imóvel com estacionamento próprio ou em região onde seja fácil estacionar. 
