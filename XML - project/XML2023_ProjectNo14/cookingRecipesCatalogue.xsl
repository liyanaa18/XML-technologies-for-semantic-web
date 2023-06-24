<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/">
        <html>
            <head>                
                <link rel="stylesheet" type="text/css" href="style.css"  />
                <title>Каталог с готварски рецепти</title>
            </head>

            <body>


                <h1>Каталог с български рецепти</h1>

                <div id="info-wrapper">
                    
                    <div id="sortingWrapper">

                        <div id="criteria-heading">Критерии за сортиране:</div>

                        <ul id="criteria" class="list">
                            <li>
                                <button onclick="sortByRecipes()" id="recipes-btn">Рецепти</button>
                            </li>
                            <li>
                                <button onclick="sortByRegion()" id="region-btn">Регион</button>
                            </li>
                            <li>
                                <button onclick="sortByMeal()" id="meal-btn">Тип ястие</button>
                            </li>
                            <li>
                                <button onclick="sortByKitchen()" id="kitchen-btn">Кухня</button>
                            </li>
                            <li>
                                <button onclick="sortByCookingTime()" id="cookingTime-btn">Време за приготвяне</button>
                            </li>
                        </ul>

                    </div>

                    <xsl:apply-templates select="/cookingRecipesCatalogue/recipes"/>
                    <xsl:apply-templates select="/cookingRecipesCatalogue/mealList"/>
                    <xsl:apply-templates select="/cookingRecipesCatalogue/regions"/>

                </div>

                <script>

                    function sortByRegion() {
                        document.getElementById('recipesWrapper').style.display='none';
                        document.getElementById('mealsWrapper').style.display='none';
                        document.getElementById('regionsWrapper').style.display='inline';
                        document.getElementById('kitchenWrapper').style.display='none';
                        document.getElementById('cookingTimeWrapper').style.display='none';
                    };

                    function sortByRecipes() {
                        document.getElementById('recipesWrapper').style.display='inline';
                        document.getElementById('mealsWrapper').style.display='none';
                        document.getElementById('regionsWrapper').style.display='none';
                        document.getElementById('kitchenWrapper').style.display='none';
                        document.getElementById('cookingTimeWrapper').style.display='none';
                    };

                    function sortByMeal() {
                        document.getElementById('recipesWrapper').style.display='none';
                        document.getElementById('mealsWrapper').style.display='inline';
                        document.getElementById('regionsWrapper').style.display='none';
                        document.getElementById('kitchenWrapper').style.display='none';
                        document.getElementById('cookingTimeWrapper').style.display='none';
                    };

                    function sortByKitchen() {
                        document.getElementById('recipesWrapper').style.display='none';
                        document.getElementById('mealsWrapper').style.display='none';
                        document.getElementById('regionsWrapper').style.display='none';
                        document.getElementById('kitchenWrapper').style.display='inline';
                        document.getElementById('cookingTimeWrapper').style.display='none';
                    };

                    function sortByCookingTime() {
                        document.getElementById('recipesWrapper').style.display='none';
                        document.getElementById('mealsWrapper').style.display='none';
                        document.getElementById('regionsWrapper').style.display='none';
                        document.getElementById('kitchenWrapper').style.display='none';
                        document.getElementById('cookingTimeWrapper').style.display='inline';
                    };

                </script>

            </body>
        </html>

    </xsl:template>
    
    <xsl:template match="/cookingRecipesCatalogue/recipes">
        <div id="recipesWrapper">
            <ol id="recipes" class="list">

                <xsl:apply-templates select="recipe">
                    <xsl:sort select="name" />
                </xsl:apply-templates>  
                
            </ol>
        </div>

        <div id="cookingTimeWrapper" class="hidden">
            <ol id="recipes" class="list">

                <xsl:apply-templates select="recipe">
                    <xsl:sort select="cookingTime" data-type="number"/>
                </xsl:apply-templates>  
                
            </ol>
        </div>

        <div id="kitchenWrapper" class="hidden">
            <ol id="recipes" class="list">

                <xsl:apply-templates select="recipe">
                    <xsl:sort select="kitchen" />
                </xsl:apply-templates>  
                
            </ol>
        </div>
    </xsl:template>

    <xsl:template match="/cookingRecipesCatalogue/regions">
        <div id="regionsWrapper" class="hidden">
            <xsl:for-each select="region">
                <xsl:variable name="regionName" select="@title"/>
                <xsl:variable name="regionID" select="@ID"/>

                <div class="region-wrap">
                    <h2><xsl:value-of select="$regionName"/> регион</h2>
                    <ol id="recipes" class="list">
                        <xsl:apply-templates select="/cookingRecipesCatalogue/recipes/recipe[@regionRef=$regionID]"/>
                    </ol>
                </div>

            </xsl:for-each>

        </div>
    </xsl:template>

    <xsl:template match="/cookingRecipesCatalogue/mealList">
        <div id="mealsWrapper" class="hidden">
            <xsl:for-each select="meal">
                <xsl:variable name="mealType" select="@title"/>
                <xsl:variable name="mealID" select="@type"/>

                <div class="meal-wrap">
                    <h2><xsl:value-of select="$mealType"/></h2>
                    <ol id="recipes" class="list">
                        <xsl:apply-templates select="/cookingRecipesCatalogue/recipes/recipe[meal/@typeRef=$mealID]"/>
                    </ol>
                </div>

            </xsl:for-each>

        </div>
    </xsl:template>

    <xsl:template match="/cookingRecipesCatalogue/recipes/recipe">
        <li class="recipe">
            <div class="recipe-meta">

                <xsl:variable name="image-dir">./images</xsl:variable>
                <xsl:variable name="image-name" select="image/@source"/>
                <img src="{$image-dir}/{$image-name}.jpg"/>

                <div class="recipe-meta-text">
                    <h3><xsl:value-of select="name"/></h3>
                    <p>Автор: <xsl:value-of select="author"/></p>
                    <p>Кухня: <xsl:value-of select="kitchen"/></p>

                    <xsl:variable name="typeRef" select="meal/@typeRef"/>
                    <p>Тип ястие: <xsl:value-of select="/cookingRecipesCatalogue/mealList/meal[@type=$typeRef]/@title" /></p>
                    <p>Време за приготвяне(мин): <xsl:value-of select="cookingTime" /></p>

                    <xsl:variable name="regionRef" select="@regionRef"/>
                    <p>Регион: <xsl:value-of select="/cookingRecipesCatalogue/regions/region[@ID=$regionRef]/@title"/></p>

                    <xsl:if test="./origin">
                        <p>Край: <xsl:value-of select="origin"/></p>
                    </xsl:if>
                </div>
            </div>

            
            <div class="recipe-description">
                <xsl:apply-templates select="./ingredients"/>
                <xsl:apply-templates select="./process"/>
                <xsl:apply-templates select="./servingMethod"/>
                <xsl:apply-templates select="./matchDrinks"/>
                <xsl:apply-templates select="./techniques"/>
                <xsl:apply-templates select="./medicalParameters"/>
            </div>
        </li>
    </xsl:template>

    <xsl:template match="/cookingRecipesCatalogue/recipes/recipe/ingredients">
        <div id="ingredients-wrapper">
            <h3>Съставки:</h3>
            <ul>
                <xsl:for-each select="./list/product">
                    <li><xsl:value-of select="."/>
                        <xsl:if test="@quantity">
                            - <xsl:value-of select="@quantity"/>
                        </xsl:if>
                    </li>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>

    <xsl:template match="/cookingRecipesCatalogue/recipes/recipe/process">
        <div id="process-wrapper">
            <h3>Приготвяне:</h3>
            <ol>
                <xsl:for-each select="./step">
                    <li><xsl:value-of select="."/></li>
                </xsl:for-each>
            </ol>
        </div>
    </xsl:template>

    <xsl:template match="/cookingRecipesCatalogue/recipes/recipe/servingMethod">
        <div>
            <h3>Как се сервира?</h3>
            <p><xsl:value-of select="."/></p>
        </div>
    </xsl:template>

    
    <xsl:template match="/cookingRecipesCatalogue/recipes/recipe/matchDrinks">
        <div id="drink-wrapper">
            <h3>Подхождащи напитки:</h3>
            <ul>
                <xsl:for-each select="./drink">
                    <li><xsl:value-of select="."/></li>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>


    <xsl:template match="/cookingRecipesCatalogue/recipes/recipe/techniques">
        <xsl:variable name="techniquesCount" select="count(technique)"/>
        <xsl:if test="$techniquesCount &gt; 0">
            <div id="techniques-wrapper">
                <h3>Използвани техники:</h3>
                <ul>
                    <xsl:for-each select="./technique">
                        <li>
                            <xsl:variable name="techniqueRef" select="@techniqueRef"/>
                            <h4><xsl:value-of select="$techniqueRef"/></h4>
                            <p>
                                <xsl:value-of select="/cookingRecipesCatalogue/techniquesList/technique[@name=$techniqueRef]/description"/>           
                            </p>
                        </li>
                    </xsl:for-each>
                </ul>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="/cookingRecipesCatalogue/recipes/recipe/medicalParameters">
        <div>
            <h3>Полезни свойства:</h3>
            <p class="break-all"><xsl:value-of select="descriptionMedicalParameters"/></p>
        </div>
    </xsl:template>

</xsl:stylesheet>