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
var height = 50;
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
    ctx.fillRect(start[i], 0, end[i] - start[i], height);
  }
}

void drawTrack(CanvasRenderingContext2D ctx) {
  ctx..fillStyle = "lightgray"
    ..fillRect(0, 0, width, height);
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
      ..fillRect(x, 0, 1, height);
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
      ..fillRect(x, 0, 1, height);
  } else{ //rand:

    if(!pos_rand.contains(x)) {
      pos_rand.add(x);
    }

    ctx..fillStyle = "blue"
      ..fillRect(x, 0, 1, height);
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


  // P Value:

  var pValue = fisher(counter_obs, counter_rand, pos_obs.length - counter_obs ,pos_rand.length - counter_rand);
  querySelector('#stat').text = "P-Value: $pValue";

  if(pValue <= 0.05){
    querySelector('#stat').style.backgroundColor = "green";
  } else{
    querySelector('#stat').style.backgroundColor = "gray";
  }


  // fold change

  var fc = fold_change(counter_obs, counter_rand, pos_obs.length - counter_obs ,pos_rand.length - counter_rand);
  querySelector('#fc').text = "Fold-change: $fc";
}

double fold_change(a,b,c,d) {
  return log((a/c) / (b/d)).abs();
}

double fisher(a,b,c,d){
  return (fak(a+b,a) * fak(c+d,c)) / fak(a+b+c+d, a+c);
}

double fak(n, k) {
  if(k >  n)
    throw Error;
  if(k == 0)
    return 1.0;
  if(k > n/2)
    return fak(n,n-k);
  return n * fak(n-1,k-1) / k;
}

