# Aristotle proof job: classify the live even Krein-sector signature

Name this project `codex-pub-krein-sector-signature-classification-20260711`.

Prove all nine theorem holes in `ChannelKreinSectorSignature/Main.lean` with
definitions, hypotheses, quantifiers, and conclusions unchanged. Run the
narrow file first.

Scientific purpose: upgrade Paper F's one negative metric witness to a complete
normal-form and signature-coordinate theorem. Every chirality-even,
Krein-self-adjoint rational `4 x 4` carrier matrix should have exactly six
coordinates, with adjoint-induced self-pairing
`a^2+d^2+e^2+g^2-2b^2-2f^2`. The diagonal four-coordinate sector is positive
definite and the remaining two-coordinate plane is strictly negative away from
zero.

Audit the signs against `eta=diag(1,-1,1,-1)` and
`Gam=diag(1,1,-1,-1)`. The existential normal form must be exhaustive and the
coordinate uniqueness theorem must be retained. Do not replace the result by
specific witnesses or floating-point computation.

Scientific boundary: this is an exact signature classification of one supplied
Krein form. It does not derive the diagonal sector as the physical sector or
prove that the named channels lie in it.

```yaml
aristotle:
  project_id: ed445871-8aca-48a9-a150-4193a2972df6
  target_file: ChannelKreinSectorSignature/Main.lean
  expected_module: ChannelKreinSectorSignature.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-krein-sector-signature-classification-20260711-project
  output_dir: AgentTasks/aristotle-output/ed445871-8aca-48a9-a150-4193a2972df6
  status: integrated
  run: overnight-publication-run-2026-07-11
  owner: Codex
```
