import PhysicsSM.Algebra.Jordan.H3O
import PhysicsSM.Algebra.Jordan.H3OJordanDiag
import PhysicsSM.Algebra.Jordan.H3OJordanX
import PhysicsSM.Algebra.Jordan.H3OJordanY
import PhysicsSM.Algebra.Jordan.H3OJordanZ

/-!
# Algebra.Jordan.H3OJordan

The Jordan identity for the exceptional Jordan algebra `h₃(𝕆)`.

## Mathematical context

The Albert algebra `h₃(𝕆)` of 3×3 Hermitian octonionic matrices, with
the Jordan product `A ○ B = (AB + BA)/2`, satisfies the Jordan identity:

```text
(a ○ b) ○ (a ○ a) = a ○ (b ○ (a ○ a))
```

This is a celebrated result in the theory of exceptional Jordan algebras.

## Proof strategy

After destructuring both `H3O` elements into their 27 real coordinates
(3 real diagonal + 3 × 8 octonion coordinates), and expanding the Jordan
product formula through the octonion multiplication table, every coordinate
of the Jordan identity becomes a polynomial identity in 54 real variables.
These are verified by the `ring` tactic.

The proof is split across four files to manage memory:
- `H3OJordanDiag.lean`: alpha, beta, gamma components
- `H3OJordanX.lean`: x component (8 polynomial identities)
- `H3OJordanY.lean`: y component (8 polynomial identities)
- `H3OJordanZ.lean`: z component (8 polynomial identities)

Source: Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002), §3–4.
Albert, "On a Certain Algebra of Quantum Mechanics", Ann. of Math. 35 (1934).

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Algebra.Jordan.H3OJordan

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O

local infixl:70 " ○ " => jordanProduct

/--
The Jordan identity for `h₃(𝕆)`:

```text
(a ○ b) ○ (a ○ a) = a ○ (b ○ (a ○ a))
```

This establishes that `h₃(𝕆)` with the Jordan product is a Jordan algebra,
the unique exceptional simple Jordan algebra (the Albert algebra).

The proof expands both sides to 27 real polynomial coordinates (3 diagonal +
3 × 8 octonion coordinates) in 54 real variables and verifies each polynomial
identity using `ring`. The component proofs are in `H3OJordanDiag.lean`,
`H3OJordanX.lean`, `H3OJordanY.lean`, and `H3OJordanZ.lean`.
-/
theorem jordanIdentity_H3O (a b : H3O) :
    (a ○ b) ○ (a ○ a) = a ○ (b ○ (a ○ a)) := by
  ext
  · exact jordanIdentity_alpha a b
  · exact jordanIdentity_beta a b
  · exact jordanIdentity_gamma a b
  · exact congrArg Octonion.c0 (jordanIdentity_x a b)
  · exact congrArg Octonion.c1 (jordanIdentity_x a b)
  · exact congrArg Octonion.c2 (jordanIdentity_x a b)
  · exact congrArg Octonion.c3 (jordanIdentity_x a b)
  · exact congrArg Octonion.c4 (jordanIdentity_x a b)
  · exact congrArg Octonion.c5 (jordanIdentity_x a b)
  · exact congrArg Octonion.c6 (jordanIdentity_x a b)
  · exact congrArg Octonion.c7 (jordanIdentity_x a b)
  · exact congrArg Octonion.c0 (jordanIdentity_y a b)
  · exact congrArg Octonion.c1 (jordanIdentity_y a b)
  · exact congrArg Octonion.c2 (jordanIdentity_y a b)
  · exact congrArg Octonion.c3 (jordanIdentity_y a b)
  · exact congrArg Octonion.c4 (jordanIdentity_y a b)
  · exact congrArg Octonion.c5 (jordanIdentity_y a b)
  · exact congrArg Octonion.c6 (jordanIdentity_y a b)
  · exact congrArg Octonion.c7 (jordanIdentity_y a b)
  · exact congrArg Octonion.c0 (jordanIdentity_z a b)
  · exact congrArg Octonion.c1 (jordanIdentity_z a b)
  · exact congrArg Octonion.c2 (jordanIdentity_z a b)
  · exact congrArg Octonion.c3 (jordanIdentity_z a b)
  · exact congrArg Octonion.c4 (jordanIdentity_z a b)
  · exact congrArg Octonion.c5 (jordanIdentity_z a b)
  · exact congrArg Octonion.c6 (jordanIdentity_z a b)
  · exact congrArg Octonion.c7 (jordanIdentity_z a b)

end PhysicsSM.Algebra.Jordan.H3OJordan
