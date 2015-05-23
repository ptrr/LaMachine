#!/bin/bash

echo "=== VIRTUALENV LAMACHINE BOOTSTRAP ===">&2

CONDA=0
if [ ! -z "$CONDA_DEFAULT_ENV" ]; then
    echo "Running in Anaconda environment..." >&2
    if [ ! -d conda-meta ]; then
        echo "Make sure your current working directory is in the root of the anaconda environment ($CONDA_DEFAULT_ENV)" >&2
        exit 2
    fi
    CONDA=1
elif [ -z "$VIRTUAL_ENV" ]; then
    echo "This should be run within a virtualenv! None detected! Make and activate one first:" >&2
    echo "$ virtualenv lamachine" >&2
    echo "$ . lamachine/bin/activate" >&2
    echo "(lamachine)$ $0" >&2
    exit 2 
fi

fatalerror () {
    echo "================ FATAL ERROR ==============" >&2
    echo "A error occured during installation!!" >&2
    echo $1 >&2
    echo "===========================================" >&2
    exit 2
}

error () {
    echo "================= ERROR ===================" >&2
    echo $1 >&2
    echo "===========================================" >&2
    sleep 3
}


activate='
# This file must be used with "source bin/activate" *from bash or zsh*
# you cannot run it directly
# EDITED by LaMachine

deactivate () {
    unset PYTHONPATH

    unset pydoc

    # reset old environment variables
    if [ -n "$_OLD_VIRTUAL_PATH" ] ; then
        PATH="$_OLD_VIRTUAL_PATH"
        export PATH
        unset _OLD_VIRTUAL_PATH
    fi
    if [ -n "$_OLD_VIRTUAL_PYTHONHOME" ] ; then
        PYTHONHOME="$_OLD_VIRTUAL_PYTHONHOME"
        export PYTHONHOME
        unset _OLD_VIRTUAL_PYTHONHOME
    fi
    if [ -n "$_OLD_VIRTUAL_LD_LIBRARY_PATH" ] ; then
        LD_LIBRARY_PATH="$_OLD_VIRTUAL_LD_LIBRARY_PATH"
        export LD_LIBRARY_PATH
        unset _OLD_VIRTUAL_LD_LIBRARY_PATH
    fi
    if [ -n "$_OLD_VIRTUAL_LD_RUN_PATH" ] ; then
        LD_RUN_PATH="$_OLD_VIRTUAL_LD_RUN_PATH"
        export LD_RUN_PATH
        unset _OLD_VIRTUAL_LD_RUN_PATH
    fi
    if [ -n "$_OLD_VIRTUAL_CPATH" ] ; then
        CPATH="$_OLD_VIRTUAL_CPATH"
        export CPATH
        unset _OLD_VIRTUAL_CPATH
    fi

    # This should detect bash and zsh, which have a hash command that must
    # be called to get it to forget past commands.  Without forgetting
    # past commands the $PATH changes we made may not be respected
    if [ -n "$BASH" -o -n "$ZSH_VERSION" ] ; then
        hash -r 2>/dev/null
    fi

    if [ -n "$_OLD_VIRTUAL_PS1" ] ; then
        PS1="$_OLD_VIRTUAL_PS1"
        export PS1
        unset _OLD_VIRTUAL_PS1
    fi

    unset VIRTUAL_ENV
    if [ ! "$1" = "nondestructive" ] ; then
    # Self destruct!
        unset -f deactivate
    fi
}

# unset irrelevant variables
deactivate nondestructive


VIRTUAL_ENV="%VIRTUAL_ENV%"
export VIRTUAL_ENV

_OLD_VIRTUAL_PATH="$PATH"
PATH="$VIRTUAL_ENV/bin:$PATH"
export PATH

_OLD_VIRTUAL_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
case ":$LD_LIBRARY_PATH:" in
      *":$VIRTUAL_ENV/lib:"*) :;; # already there
      *) export LD_LIBRARY_PATH="$VIRTUAL_ENV/lib:$LD_LIBRARY_PATH";; 
esac

_OLD_VIRTUAL_LD_RUN_PATH="$LD_RUN_PATH"
case ":$LD_RUN_PATH:" in
      *":$VIRTUAL_ENV/lib:"*) :;; # already there
      *) export LD_RUN_PATH="$VIRTUAL_ENV/lib:$LD_RUN_PATH";; 
esac

export _OLD_VIRTUAL_CPATH="$CPATH"
case ":$CPATH:" in
      *":$VIRTUAL_ENV/include:"*) :;; # already there
      *) export CPATH="$VIRTUAL_ENV/include:$CPATH";; 
esac

# unset PYTHONHOME if set
# this will fail if PYTHONHOME is set to the empty string (which is bad anyway)
# could use `if (set -u; : $PYTHONHOME) ;` in bash
if [ -n "$PYTHONHOME" ] ; then
    _OLD_VIRTUAL_PYTHONHOME="$PYTHONHOME"
    unset PYTHONHOME
fi

if [ -z "$VIRTUAL_ENV_DISABLE_PROMPT" ] ; then
    _OLD_VIRTUAL_PS1="$PS1"
    if [ "x" != x ] ; then
        PS1="$PS1"
    else
    if [ "`basename \"$VIRTUAL_ENV\"`" = "__" ] ; then
        # special case for Aspen magic directories
        # see http://www.zetadev.com/software/aspen/
        PS1="[`basename \`dirname \"$VIRTUAL_ENV\"\``] $PS1"
    else
        PS1="(`basename \"$VIRTUAL_ENV\"`)$PS1"
    fi
    fi
    export PS1
fi

alias pydoc="python -m pydoc"

# This should detect bash and zsh, which have a hash command that must
# be called to get it to forget past commands.  Without forgetting
# past commands the $PATH changes we made may not be respected
if [ -n "$BASH" -o -n "$ZSH_VERSION" ] ; then
    hash -r 2>/dev/null
fi'

activate_conda='
VIRTUAL_ENV="%VIRTUAL_ENV%"

_OLD_VIRTUAL_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
case ":$LD_LIBRARY_PATH:" in
      *":$VIRTUAL_ENV/lib:"*) :;; # already there
      *) export LD_LIBRARY_PATH="$VIRTUAL_ENV/lib:$LD_LIBRARY_PATH";; 
esac

_OLD_VIRTUAL_LD_RUN_PATH="$LD_RUN_PATH"
case ":$LD_RUN_PATH:" in
      *":$VIRTUAL_ENV/lib:"*) :;; # already there
      *) export LD_RUN_PATH="$VIRTUAL_ENV/lib:$LD_RUN_PATH";; 
esac

export _OLD_VIRTUAL_CPATH="$CPATH"
case ":$CPATH:" in
      *":$VIRTUAL_ENV/include:"*) :;; # already there
      *) export CPATH="$VIRTUAL_ENV/include:$CPATH";; 
esac'

echo "Modifying environment">&2
if [ "$CONDA" == "1" ]; then
    VIRTUAL_ENV=`pwd`
    mkdir $VIRTUAL_ENV/activate.d/
    echo -e $activate_conda > $VIRTUAL_ENV/activate.d/lamachine.sh
    chmod a+x $VIRTUAL_ENV/activate.d/lamachine.sh
    VIRTUAL_ENV_ESCAPED=${VIRTUAL_ENV//\//\\/}
    sed -i "s/%VIRTUAL_ENV%/${VIRTUAL_ENV_ESCAPED}/" $VIRTUAL_ENV/activate.d/lamachine.sh || fatalerror "Error modifying environment"
else
    echo -e $activate > $VIRTUAL_ENV/bin/activate  
    VIRTUAL_ENV_ESCAPED=${VIRTUAL_ENV//\//\\/}
    sed -i "s/%VIRTUAL_ENV%/${VIRTUAL_ENV_ESCAPED}/" $VIRTUAL_ENV/bin/activate || fatalerror "Error modifying environment"
fi
cp $0 $VIRTUAL_ENV/bin/lamachine-update.sh

if [ ! -d $VIRTUAL_ENV/src ]; then
    mkdir $VIRTUAL_ENV/src
fi
cd $VIRTUAL_ENV/src

if [ -z "$_OLD_VIRTUAL_LD_LIBRARY_PATH" ] ; then
    export _OLD_VIRTUAL_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
fi
case ":$LD_LIBRARY_PATH:" in
      *":$VIRTUAL_ENV/lib:"*) :;; # already there
      *) export LD_LIBRARY_PATH="$VIRTUAL_ENV/lib:$LD_LIBRARY_PATH";; 
esac

if [ -z "$_OLD_VIRTUAL_LD_RUN_PATH" ] ; then
    export _OLD_VIRTUAL_LD_RUN_PATH="$LD_RUN_PATH"
fi
case ":$LD_RUN_PATH:" in
      *":$VIRTUAL_ENV/lib:"*) :;; # already there
      *) export LD_RUN_PATH="$VIRTUAL_ENV/lib:$LD_RUN_PATH";; 
esac

if [ -z "$_OLD_VIRTUAL_CPATH" ] ; then
    export _OLD_VIRTUAL_CPATH="$CPATH"
fi
case ":$CPATH:" in
      *":$VIRTUAL_ENV/include:"*) :;; # already there
      *) export CPATH="$VIRTUAL_ENV/include:$CPATH";; 
esac



PROJECTS="ticcutils libfolia ucto timbl timblserver mbt frogdata"

for project in $PROJECTS; do
    echo 
    echo "--------------------------------------------------------"
    echo "Installing/updating $project"
    echo "--------------------------------------------------------"
    if [ ! -d $project ]; then
        git clone https://github.com/proycon/$project || fatalerror "Unable to clone git repo for $project"
        cd $project
    else
        cd $project
        pwd
        if [ -d .svn ]; then
            svn update || fatalerror "Unable to svn update $project" #a cheat for versions with Tilburg's SVN as primary source rather than github
        else
            git pull || fatalerror "Unable to git pull $project"
        fi
    fi
    bash bootstrap.sh || fatalerror "$project bootstrap failed"
    ./configure --prefix=$VIRTUAL_ENV  || fatalerror "$project configure failed"
    make || fatalerror "$project make failed"
    make install || fatalerror "$project make install failed"
    cd ..
done

if [ -f /usr/bin/python2.7 ]; then
    echo 
    echo "--------------------------------------------------------"
    echo "Installing frog"
    echo "--------------------------------------------------------"
    if [ ! -d frog ]; then
        git clone https://github.com/proycon/frog
        cd frog
    else
        cd frog
        if [ -d .svn ]; then
            svn update
        else
            git pull
        fi
    fi
    bash bootstrap.sh || fatalerror "frog bootstrap failed"
    ./configure --prefix=$VIRTUAL_ENV --with-python=/usr/bin/python2.7 || fatalerror "frog configure failed"
    make || fatalerror "frog make failed"
    make install || fatalerror "frog make install failed"
    cd ..
else
    echo "Skipping installation of Frog because Python 2.7 was not found in /usr/bin/python2.7 (needed for the parser)">&2
fi

echo 
echo "--------------------------------------------------------"
echo "Installing Python dependencies from the Python Package Index"
echo "--------------------------------------------------------"
pip install -U cython ipython numpy scipy matplotlib lxml django


PYTHONPROJECTS="pynlpl folia foliadocserve flat"

echo 
echo "--------------------------------------------------------"
echo "Installing Python packages"
echo "--------------------------------------------------------"
for project in $PYTHONPROJECTS; do
    echo 
    echo "--------------------------------------------------------"
    echo "Installing $project">&2
    echo "--------------------------------------------------------"
    if [ ! -d $project ]; then
        git clone https://github.com/proycon/$project
        cd $project
    else
        cd $project
        git pull
    fi
    python setup.py install --prefix=$VIRTUAL_ENV || fatalerror "setup.py install $project failed"
    cd ..
done

echo "--------------------------------------------------------"
echo "Installing python-ucto"
echo "--------------------------------------------------------"
if [ ! -d python-ucto ]; then
    git clone https://github.com/proycon/python-ucto
    cd python-ucto
else
    cd python-ucto 
    git pull
    rm *_wrapper.cpp >/dev/null 2>/dev/null #forcing recompilation of cython stuff
fi
python setup.py build_ext --include-dirs=$VIRTUAL_ENV/include --library-dirs=$VIRTUAL_ENV/lib install --prefix=$VIRTUAL_ENV
cd ..


echo "--------------------------------------------------------"
echo "Installing python-timbl"
echo "--------------------------------------------------------"
if [ ! -d python-timbl ]; then
    git clone https://github.com/proycon/python-timbl
    cd python-timbl
else
    cd python-timbl
    git pull
fi
if [ -d /usr/lib/x86_64-linux-gnu ]; then
    python setup3.py build_ext --boost-library-dir=/usr/lib/x86_64-linux-gnu install
else
    python setup3.py build_ext install
fi
cd ..

if [ -f /usr/bin/python2.7 ]; then
    echo "--------------------------------------------------------"
    echo "Installing python-frog"
    echo "--------------------------------------------------------"
    if [ ! -d python-frog ]; then
        git clone https://github.com/proycon/python-frog
        cd python-frog
    else
        cd python-frog
        git pull
        rm *_wrapper.cpp >/dev/null 2>/dev/null #forcing recompilation of cython stuff
    fi
    python setup.py install
    cd ..
fi

echo "--------------------------------------------------------"
echo "Installing colibri-core"
echo "--------------------------------------------------------"
if [ ! -d colibri-core ]; then
    git clone https://github.com/proycon/colibri-core
    cd colibri-core
else
    cd colibri-core 
    git pull
    rm *_wrapper.cpp >/dev/null 2>/dev/null #forcing recompilation of cython stuff
fi
python setup.py build_ext --include-dirs=$VIRTUAL_ENV/include/colibri-core --library-dirs=$VIRTUAL_ENV/lib install --prefix=$VIRTUAL_ENV
cd ..

echo "--------------------------------------------------------"
echo "All done!">&2
