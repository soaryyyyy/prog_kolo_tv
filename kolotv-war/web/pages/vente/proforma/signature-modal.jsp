<%@ page import="utilitaire.*" %>
<%
    String from = request.getParameter("from"); // ex: "but=vente/vente-fiche.jsp
    String id = request.getParameter("id");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Signature</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="${pageContext.request.contextPath}/dist/js/libs/jquery.js"></script>
    <script src="${pageContext.request.contextPath}/dist/js/libs/jSignature.min.noconflict.js"></script>

    <style>
        body {
            margin: 0;
            padding: 15px;
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }
        #signatureparent {
            color: #2c3d91;
            background-color: #e9ecef;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 4px;
            border: 1px solid #ced4da;
            text-align: center;
        }
        #signature {
            border: 1px solid #6c757d;
            background-color: white;
            height: 250px;
            width: 250px;
            margin: 0 auto;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            margin: 5px;
        }
        .btn-primary {
            background-color: #2c3d91;
            color: white;
        }
        .btn-default {
            background-color: #6c757d;
            color: white;
        }
        .modal-header {
            background: #2c3d91;
            color: white;
            padding: 12px 15px;
            margin-bottom: 15px;
            text-align: center;
        }
        .modal-title {
            font-size: 16px;
            margin: 0;
        }
        #tools {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 15px;
        }
        .signature-instruction {
            font-weight: bold;
            margin-bottom: 10px;
            font-size: 14px;
        }
    </style>
</head>
<body>

<div class="modal-header">
    <h4 class="modal-title">Signature</h4>
</div>

<div>
    <div id="content">
        <div id="signatureparent">
            <div class="signature-instruction">Signez dans le cadre ci-dessous</div>
            <div id="signature"></div>
        </div>
        <div id="tools">
            <button type="button" class="btn btn-default" onclick="resetSignature()">Effacer</button>
            <form action="${pageContext.request.contextPath}/SaveSignatureServlet" method="post" style="display: inline;">
                <input type="hidden" name="signature" id="impression1"/>
                <input type="hidden" name="from" value="<%= from %>"/>
                <input type="hidden" name="id" value="<%= id %>"/>
                <button class="btn btn-primary" type="submit" id="btnImprimer1">Sauvegarder</button>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/dist/js/libs/jquery.js"></script>
<script type="text/javascript">
    jQuery.noConflict()
</script>
<script>
    /*  @preserve
    jQuery pub/sub plugin by Peter Higgins (dante@dojotoolkit.org)
    Loosely based on Dojo publish/subscribe API, limited in scope. Rewritten blindly.
    Original is (c) Dojo Foundation 2004-2010. Released under either AFL or new BSD, see:
    http://dojofoundation.org/license for more information.
    */
    (function ($) {
        var topics = {};
        $.publish = function (topic, args) {
            if (topics[topic]) {
                var currentTopic = topics[topic],
                    args = args || {};

                for (var i = 0, j = currentTopic.length; i < j; i++) {
                    currentTopic[i].call($, args);
                }
            }
        };
        $.subscribe = function (topic, callback) {
            if (!topics[topic]) {
                topics[topic] = [];
            }
            topics[topic].push(callback);
            return {
                "topic": topic,
                "callback": callback
            };
        };
        $.unsubscribe = function (handle) {
            var topic = handle.topic;
            if (topics[topic]) {
                var currentTopic = topics[topic];

                for (var i = 0, j = currentTopic.length; i < j; i++) {
                    if (currentTopic[i] === handle.callback) {
                        currentTopic.splice(i, 1);
                    }
                }
            }
        };
    })(jQuery);

</script>
<script src="${pageContext.request.contextPath}/dist/js/libs/jSignature.min.noconflict.js"></script>
<script>
    (function ($) {

        $(document).ready(function () {

            // Initialiser la signature avec des dimensions carrées
            var $sigdiv = $("#signature").jSignature({
                'UndoButton': true,
                'width': 250,   // Largeur fixe carrée
                'height': 250   // Hauteur fixe carrée
            });

            var $tools = $('#tools')
            var $extraarea = $('#displayarea')
            var pubsubprefix = 'jSignature.demo.'

            var export_plugins = $sigdiv.jSignature('listPlugins', 'export')
            var name

            // Mettre à jour le champ caché avec les données de signature
            $('#btnImprimer1').bind('click', function (e) {
                var data = $sigdiv.jSignature('getData', 'default');
                $('#impression1').attr("value", data);
            });

            // Ajouter le bouton reset
            $('<button type="button" class="btn btn-default">Effacer</button>')
                .bind('click', function (e) {
                    $sigdiv.jSignature('reset')
                })
                .appendTo($tools);

            if (Modernizr.touch) {
                $('#scrollgrabber').height($('#content').height())
            }

        })

    })(jQuery)
</script>

</body>
</html>