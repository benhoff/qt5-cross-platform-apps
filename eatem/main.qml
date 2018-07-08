import QtQuick 2.11
import QtQuick.Controls 1.4


ApplicationWindow {
    id: window
    title: "eatem"
    visible: true

    Canvas {
        id: canvas
        anchors.fill: parent
        focus: true
        contextType: "2d"
        property color clear_color: 'white'
        property var context

        onPaint: {
            context = getContext("2d");
            game_loop();
        }

        function game_loop()
        {
            // You can't block with JavaScript...
            // So normally this would look like a `while (true):` loop
            // But since you never go back into the event loop with that pattern,
            // your user interface would hang and become unresponsive.
            // So instead we recursively register this same function
            // on the next animation frame, using the `requestAnimationFrame` method
            requestAnimationFrame(game_loop);

            // Set the fill style to clear the background
            context.fillStyle = clear_color;

            // Clear the background
            context.clearRect(0, 0, canvas.width, canvas.height);

            // draw the food
            draw_food();

            // and draw the players
            draw_players();
        }

        function translate(object)
        {
            var relative_x = object.x + (window.contentItem.width/2) - this_player.x;
            var relative_y = object.y + (window.contentItem.height/2) - this_player.y;

            // FIXME: figure out what this magic number should actually be
            var zoomed_radius = object.radius * this_player.zoom_factor;
            return [relative_x, relative_y, zoomed_radius];
        }

        function draw_food()
        {
            var x_y_radius, food;

            for (var i = 0; i < feed.length / 2; i++)
            {
                food = feed[i];
                if (!food.enabled)
                    continue;
                x_y_radius = translate(food)
                context.beginPath();
                context.fillStyle = food.hue;
                context.arc(x_y_radius[0],
                            x_y_radius[1],
                            x_y_radius[2], 0, 2*Math.PI);

                context.fill();
            }
        }

        function draw_players()
        {
            var x_y_radius, player, cell;

            for (var z=0; z < players.length; z++)
            {
                player = players[z];
                context.fillStyle = player.hue;
                for (var cell_number=0; cell_number < player.cells.length; cell_number++)
                {
                    cell = player.cells[cell_number];
                    x_y_radius = translate(cell);
                    context.beginPath();
                    context.arc(x_y_radius[0],
                                x_y_radius[1],
                                x_y_radius[2],
                                0, 2*Math.PI);

                    context.fill();
                }
            }
        }

        Keys.onSpacePressed: {
            // FIXME: this is wrong now
            var x_y = translate_mouse(mouse);
            this_player.request_split(x_y[0], x_y[1]);
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
        }

        function translate_mouse(mouse)
        {
            // NOTE: probably need to scale this as well
            return [mouse.mouseX - (window.contentItem.width/2) + this_player.x,
                    mouse.mouseY - (window.contentItem.height/2) + this_player.y];
        }

        Timer {
            id: lineTimer
            interval: 10
            repeat: true
            running: true
            onTriggered: {
                var x_y = canvas.translate_mouse(mouse);
                this_player.request_coordinates(x_y[0], x_y[1]);
                canvas.requestPaint();
            }
        }
    }
}
