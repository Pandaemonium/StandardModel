# Summary of changes for run 92316e8c-c70c-4f6e-8b0b-cd69bbf91180
Closed the Gate C1 shifted-CKM mass-window / sign-straddling obligation by formalizing and fully proving the certificate in `RequestProject/MassWindow.lean` (builds clean, no proof placeholders, only standard kernel dependencies `propext`/`Classical.choice`/`Quot.sound`).

Model. A corner is encoded by its `level : ℕ` (`level = 0` is the single physical/zero corner, `level > 0` the 15 unwanted corners). The CKM mass attached to a corner is `MCKM level = if level = 0 then 15 else -1`, and the leading-branch Wilson term is `Wbranch r R level = r * (15 * R - MCKM level)`. This realizes `W_branch^(1) = r (15 R − M_CKM)`, an inverse-kernel mass-window construction (no propagator-zero language used).

Diagnostic R = I results.
- `Wbranch_diag_zero : Wbranch r 1 0 = 0` and `Wbranch_diag_pos : level ≠ 0 → Wbranch r 1 level = 16 * r` — i.e. W = 0 at the physical corner and W = 16r at all others.
- `massWindow_diag_light` : `0 < m0 → Wbranch r 1 0 - m0 < 0` (physical corner on the light/negative side).
- `massWindow_diag_heavy` : `m0 < 16*r → level ≠ 0 → 0 < Wbranch r 1 level - m0` (every unwanted corner heavy/positive).
- `massWindow_diag` : the combined one-sector sign split for `0 < m0 < 16r`.

Explicit margin. The certificate carries margin `min m0 (16r − m0)`:
- `massWindow_diag_margin_light` : `Wbranch r 1 0 - m0 ≤ -(min m0 (16*r - m0))`;
- `massWindow_diag_margin_heavy` : `min m0 (16*r - m0) ≤ Wbranch r 1 level - m0` for `level ≠ 0`.

General branch-weight R package. With `R : Corner → ℝ` and a `level : Corner → ℕ` projection, the clean assumption package is: `R c = R0` on the zero corner; `Rlo ≤ R c` on all unwanted corners; `r > 0`; and `m0` strictly inside the window `(15 r (R0 − 1), r (15 Rlo + 1))`.
- `massWindow_general_light` : light side from `15*r*(R0-1) < m0`.
- `massWindow_general_heavy` : heavy side from `r > 0`, the lower bound `Rlo ≤ R c`, and `m0 < r*(15*Rlo + 1)`.
- `massWindow_general` : the combined one-sector split.
- `massWindow_general_window_nonempty` : the window is nonempty exactly when `15 r (R0 − 1) < r (15 Rlo + 1)`. Setting `R0 = Rlo = 1` recovers the diagnostic window `(0, 16r)`.

How this certifies C159 MassWindow / SignStraddling. The pair (`massWindow_diag` / `massWindow_general`) proves that after subtracting the window parameter `m0`, the shifted Wilson term is strictly negative on exactly the one physical corner and strictly positive on every one of the 15 unwanted corners, with the explicit nonzero margin `min(m0, 16r − m0)` (diagnostic case). This is precisely a finite mass-window with sign straddling: one light sector, fifteen heavy, separated by a quantified gap — discharging the MassWindow/SignStraddling obligation.
