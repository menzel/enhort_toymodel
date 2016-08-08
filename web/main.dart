// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:math';

CanvasElement canvas;
CanvasRenderingContext2D ctx;
var start = [20, 100, 150, 500, 700];
var end = [70, 130, 350, 640, 750];
var pos_rand = [];
var pos_obs = [];
var rng = new Random();
var heigth = 50;
var width = 800;

void main() {

  canvas = querySelector('#canvas');
  ctx = canvas.getContext('2d');
  var init = 0;

  drawTrack(ctx);
  ctx.canvas.onClick.listen((e){
    if(init != 1){
      drawIntervals(ctx, start, end);
      ctx.canvas.onClick.listen(handler);
      init = 1;
    }
  });


  var rand_btn = querySelector('#rand_btn');
  rand_btn.onClick.listen((e){

    generateRandom(ctx, pos_obs.length);

  });
}

void drawIntervals(CanvasRenderingContext2D ctx, List start, List end) {
     ctx.fillStyle = "lightblue";
     for(var i = 0; i < start.length; i++){
       ctx.fillRect(start[i], 0, end[i] - start[i], heigth);
     }
}

void drawTrack(CanvasRenderingContext2D ctx) {
     ctx..fillStyle = "lightgray"
      ..fillRect(0, 0, width, heigth);
}

void generateRandom(ctx, n){
  for(var i = 0; i < n ; i++){
    var x = rng.nextInt(width);

    if(!pos_rand.contains(x)) {
      pos_rand.add(x);
    } else {
      i--;
    }

    ctx..fillStyle = "blue"
    ..fillRect(x, 0, 1, heigth);
  }

  stats();
}




void handler(MouseEvent event) {

    final x = event.client.x - ctx.canvas.offset.left;
    RadioButtonInputElement radios = querySelector("#data");

    if(radios.checked){ // observed
          if(!pos_obs.contains(x)) {
            pos_obs.add(x);
          }

          ctx..fillStyle = "red"
          ..fillRect(x, 0, 1, heigth);
    } else{ //rand:

      if(!pos_rand.contains(x)) {
        pos_rand.add(x);
      }

          ctx..fillStyle = "blue"
          ..fillRect(x, 0, 1, heigth);
    }


    stats();
}


void stats(){
  var counter_rand = 0;
  var counter_obs = 0;

  for(final x in pos_rand){
    for(var i = 0; i < start.length; i++){
      if(x >= start[i] && x < end[i]){
        counter_rand++;
      }
    }
  }

  for(final x in pos_obs){
    for(var i = 0; i < start.length; i++){
      if(x >= start[i] && x < end[i]){
        counter_obs++;
      }
    }
  }

    pos_rand.sort();
    pos_obs.sort();

    querySelector('#output_obs').text = pos_obs.toString();
    querySelector('#output_rand').text = pos_rand.toString();


  querySelector('#tab_rand').text = "Inside: $counter_rand | Outside: ${pos_rand.length - counter_rand}";
  querySelector('#tab_obs').text = "Inside: $counter_obs | Outside: ${pos_obs.length - counter_obs}";

}


