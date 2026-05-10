# latex-intro

LuaLaTeX + `jlreq` 前提の日本語 LaTeX 入門資料です。

詳細な使い方は [doc/USAGE.md](doc/USAGE.md) を参照してください。

ディレクトリ構成:

```text
.
├── README.md
├── .latexmkrc
├── .vscode/
│   └── settings.json
├── bib/
│   └── references.bib
├── doc/
│   └── USAGE.md
├── fig/
│   ├── mass-spring-damper.pdf
│   └── mass-spring-damper.svg
├── out/
│   ├── aux/
│   ├── hello.pdf
│   ├── introduction-latex.pdf
│   └── minimal.pdf
├── src/
│   ├── introduction-latex.tex
│   ├── minimal.tex
│   └── hello.tex
└── sty/
    ├── latex-intro-material.sty
    └── latex-intro-warning-filter.sty
```

主要ファイル:

- [`src/introduction-latex.tex`](src/introduction-latex.tex): 本体の教材
- [`src/minimal.tex`](src/minimal.tex): 最小構成のサンプル
- [`src/hello.tex`](src/hello.tex): エンジン確認用のサンプル
- [`bib/references.bib`](bib/references.bib): `biblatex` 用の文献データ
- [`.latexmkrc`](.latexmkrc): `latexmk` / `biber` / `out/` と `out/aux/` の出力先設定

出力 PDF:

- [`out/introduction-latex.pdf`](out/introduction-latex.pdf)
- [`out/minimal.pdf`](out/minimal.pdf)
- [`out/hello.pdf`](out/hello.pdf)
