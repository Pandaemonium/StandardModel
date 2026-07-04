# YM1 Elitzur pairing bound (abstract core)

Complete both sorry-marked theorems in YM1Elitzur/ElitzurCore.lean. Do not
change the statements. Full hand-verified proof routes in the module
docstring: Target 1 is the hyperbolic inequality |1-e^{-2a}| <= (1+e^{-2a})
tanh b for |a| <= b (ratio identity 2 e^{-a} sinh a / 2 e^{-a} cosh a =
tanh a, plus tanh monotonicity); Target 2 is the finite involution-pairing
bound (reindex by Function.Involutive.toPerm, derive the paired forms
2N = sum f w (1 - e^{-2K}) and 2Z = sum w (1 + e^{-2K}), bound termwise via
Target 1). Deliver kernel-checked proofs, no sorry, no native_decide, axiom
footprint [propext, Classical.choice, Quot.sound].
