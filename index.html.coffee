# Copyright (c) 2013 Michele Bini

# This program is free software: you can redistribute it and/or modify
# it under the terms of the version 3 of the GNU General Public License
# as published by the Free Software Foundation.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

{ htmlcup } = require './htmlcup'

title = "Vaquitas need you!"

htmlcup.html5Page ->
  @head ->
    @title title
    @style type: "text/css",
      """
      body { background:pink }
      """
  @body ->
    @div "Please don't kill this baby!"
    @div "Vaquitas are the smallest marine cetacean."
    @div 'Their number has declined by 60% in 10 years, from an estimated 576 in 1997 to perhaps less than 150 individuals now, and could be extict by 2015'
    @div "A marine sactuary is Vaquitas' only chance of survival; each year 30 to 80 of them die in fishing nets"
    @div "Vaquitas now only live in a small stretch in the Gulf of California"
    @div ->
      @a href: 'http://www.youtube.com/watch?v=27pJ2S5RT8g', "Commemorative video of a baby Vaquita"
    @div ->
      @span 'Petition you can sign: '
      @a href: 'http://www.thepetitionsite.com/445/471/778/protected-reserves-for-critically-endangered-vaquita-porpoises/', "Protected Reserves for Critically Endangered Vaquita Porpoises"
