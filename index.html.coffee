# Copyright (c) 2013, 2014 Michele Bini

# This program is free software: you can redistribute it and/or modify
# it under the terms of the version 3 of the GNU General Public License
# as published by the Free Software Foundation.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

{ htmlcup } = require 'htmlcup'

title = "Vaquitas need you!"

htmlcup.html5Page ->
  @head ->
    @title title
    @style type: "text/css",
      ''''
      body {
        /* background:pink; */
        /* background: #69B2FF; */
        background: #21AFF8;
        text-align: center;
        font-size: 20px;
      }
      .banner {
        border: 4px solid white;
        border: 4px solid white rgba(255,255,255,0.9);
      }
      p {
        color:white;
        color:rgba(255,255,255,0.9);
      }
      a {
        /*
        color:rgb(200,255,255);
        color:rgba(200,255,255,0.9);
        */
        color:white;
        color:rgba(255,255,255,0.9);
        text-decoration:none;
        display: inline-block;
        border: 1px solid white;
        padding: 0 0.2em;
        border-radius: 0.2em;
        -moz-border-radius: 0.2em;
        -webkit-border-radius: 0.2em;
        -ie-border-radius: 0.2em;
      }
      a:hover {
        background-color:rgba(20,70,180,1.0);
      }
      .petition {
        padding:0.2em;
      }
      .petition a {
        font-size:127.2%;
      }
  @body ->
    @img class:"banner", src:"vaquita1.jpg"
    @p "Please don't kill this baby!"
    @p "Vaquitas are the smallest marine cetacean."
    @p 'Their number has declined by 60% in 10 years, from an estimated 576 in 1997 to 97 individuals in 2014, and could be extict by 2017'
    @p "A marine sactuary is Vaquitas' only chance of survival; each year literally tens of them die in fishing nets"
    @p "Vaquitas now only live in a small stretch in the Gulf of California"
    @p ->
      @a href: 'http://www.youtube.com/watch?v=27pJ2S5RT8g', "Commemorative video of a baby Vaquita"
    @p class:"petition", ->
      @span 'Petition you can sign: '
      @a href: 'http://www.thepetitionsite.com/445/471/778/protected-reserves-for-critically-endangered-vaquita-porpoises/', "Protected Reserves for Critically Endangered Vaquita Porpoises"
