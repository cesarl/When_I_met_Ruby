#= require vendor/zepto.min.js
Zepto ->
        links = $("a")
        links.live("click", (e) ->
                destination = $(this).attr("href")
                goPlz(destination)
                history.pushState(null, null, destination)
                e.preventDefault()
        )

        goPlz = (destination) ->
                $("#container").load(destination + " #container .content-container")

        window.onload = ->
                window.setTimeout( () ->
                        window.addEventListener("popstate", (e) ->
                                goPlz location.pathname
                        ,false)
                  , 10)