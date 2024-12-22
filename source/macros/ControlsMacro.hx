package macros;

#if macro import haxe.macro.Expr; #end

@:publicFields class ControlsMacro {
    static macro function onPress(key:ExprOf<Array<Int>>, callback:ExprOf<Void->Void>) {
        #if macro return macro Controls.bind('press', $key, () -> $callback); #end
    }

    static macro function onHold(key:ExprOf<Array<Int>>, callback:ExprOf<Void->Void>) {
        #if macro return macro Controls.bind('hold', $key, () -> $callback); #end
    }

    static macro function onRelease(key:ExprOf<Array<Int>>, callback:ExprOf<Void->Void>) {
        #if macro return macro Controls.bind('release', $key, () -> $callback); #end
    }
}