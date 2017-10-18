======
BioLua
======
    
    Copyright 2017 SweetPalma <sweet.palma@yandex.ru>

Computational biology for Lua.

.. image:: https://raw.githubusercontent.com/SweetPalma/BioLua/master/docs/biolua.gif


What is BioLua?
===============
BioLua is a Lua library, done fast and convenient biological sequences computations. BioLua is:

* **Active.** BioLua is currently being actively developed, so if you wish to use it in your project - don't hesitate to contact me regarding any issues or feature requests.

* **Fast.** BioLua was built for vanilla Lua - which is very fast itself - but it can be also stacked with LuaJIT, what makes it extremely fast for processing large amounts of biological data.

* **Free.** BioLua is licensed under MIT license, which basically allows to use it absolutely for free.


Installation
============
BioLua can be installed with `Luarocks <https://github.com/luarocks/luarocks/wiki/Download>`_:

.. code-block::

	$ luarocks install biolua

If you wish to add autocomplete and history to BioLua shell - you should install Linenoise too:

.. code-block::

	$ luarocks install linenoise

Tests can be run from :code:`tests` folder:

.. code-block::

	$ cd tests
	$ lua init.lua

Alternatively you can `clone <https://github.com/SweetPalma/BioLua.git>`_ or `download <https://github.com/SweetPalma/BioLua/archive/master.zip>`_ this repo and use "biolua" folder in your projects.


Usage
=====
After successful installation you can run BioLua shell directly from your Terminal:

.. code-block::

	$ biolua

Or connect it as Lua library in your project:

.. code-block:: lua

	local biolua = require 'biolua'
	local seq = biolua.sequence.Nucleic 'atgcatgcaaaa'
	print(seq:translate())
	...

License
=======
BioLua is licensed under the MIT License, what allows you to use it for basically anything absolutely for free.
