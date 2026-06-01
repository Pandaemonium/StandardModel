import Mathlib
import PhysicsSM.Algebra.Furey.TrialityPermutationLinear

/-!
# Triality permutation representation laws

This trusted module packages the already-formalized linear equivalences induced
by triality-role permutations as representation-style laws.

The underlying action is the pullback convention from
`TrialityTriple.permute`: the component at role `r` of `t.permute e` is
`t.proj (e.symm r)`. With this convention, composition follows Lean's
`Equiv.trans` order:

```text
(t.permute e).permute f = t.permute (e.trans f).
```

Main declarations:

- `TrialityTriple.permuteLinearEquiv_map_refl`
- `TrialityTriple.permuteLinearEquiv_map_trans`
- `TrialityTriple.cycleLinearEquiv_pow_three_apply`
- `TrialityTriple.cycleLinearEquiv_trans_three`

Source motivation: Furey and Hughes, "Three Generations and a Trio of
Trialities", arXiv:2409.17948.

Claim boundary: this is only the finite role-permutation linear algebra
scaffold. It does not define the full triality Lie algebra or any Standard
Model group action.

Provenance: this target was submitted to Aristotle as job
`3a8a8fce-12cc-482b-9b4d-f457c08aeeae`; the job ended `OUT_OF_BUDGET` without
returning a usable Lean patch. This file is a local, kernel-checked integration
over the existing `TrialityPermutationLinear` API.
-/

namespace PhysicsSM.Algebra.Furey

variable {K M : Type*} [Semiring K] [AddCommMonoid M] [Module K M]

/-! ## Representation-style identity and composition laws -/

/--
The linear equivalence induced by the identity role permutation is the identity
linear equivalence.
-/
theorem TrialityTriple.permuteLinearEquiv_map_refl :
    TrialityTriple.permuteLinearEquiv (M := M) K (Equiv.refl TrialityRole) =
      LinearEquiv.refl K (TrialityTriple M) :=
  TrialityTriple.permuteLinearEquiv_refl (M := M) K

/--
Composition of role permutations is respected by the induced linear
equivalences, using Lean's `Equiv.trans` convention.
-/
theorem TrialityTriple.permuteLinearEquiv_map_trans
    (e f : Equiv.Perm TrialityRole) :
    (TrialityTriple.permuteLinearEquiv (M := M) K e).trans
      (TrialityTriple.permuteLinearEquiv (M := M) K f) =
    TrialityTriple.permuteLinearEquiv (M := M) K (e.trans f) :=
  TrialityTriple.permuteLinearEquiv_trans (M := M) K e f

/-! ## Triality cycle laws in the linear-equivalence API -/

/--
Applying the canonical triality cycle linear equivalence three times returns
the original triple.
-/
theorem TrialityTriple.cycleLinearEquiv_pow_three_apply
    (t : TrialityTriple M) :
    TrialityTriple.cycleLinearEquiv (M := M) K
      (TrialityTriple.cycleLinearEquiv (M := M) K
        (TrialityTriple.cycleLinearEquiv (M := M) K t)) = t :=
  TrialityTriple.cycleLinearEquiv_three (M := M) K t

/--
As a linear equivalence, the third iterate of the canonical triality cycle is
the identity.
-/
theorem TrialityTriple.cycleLinearEquiv_trans_three :
    ((TrialityTriple.cycleLinearEquiv (M := M) K).trans
      (TrialityTriple.cycleLinearEquiv (M := M) K)).trans
      (TrialityTriple.cycleLinearEquiv (M := M) K) =
    LinearEquiv.refl K (TrialityTriple M) := by
  apply LinearEquiv.ext
  intro t
  exact TrialityTriple.cycleLinearEquiv_three (M := M) K t

end PhysicsSM.Algebra.Furey
