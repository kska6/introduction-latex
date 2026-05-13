# 使い方

このリポジトリは、LuaLaTeX + `jlreq` 前提で日本語 LaTeX の基本を学ぶための教材です。

## まず読むファイル

- `src/minimal.tex`: 最初にコンパイルを成功させるための最小構成
- `src/hello.tex`: 使っている LaTeX エンジンを出力で確認するためのサンプル
- `src/introduction-latex.tex`: 数式、図表、参考文献、ビルド設定まで含めた本体教材

最初は `minimal.tex` を通し、その次に `hello.tex` でエンジンを確認し、その後で `introduction-latex.tex` を読む流れを想定しています。

## ビルド方法

### 最小構成をビルドする

```sh
latexmk -lualatex src/minimal.tex
```

リポジトリのルートディレクトリで実行する想定です。`latexmk -cd -lualatex src/minimal.tex` のように `-cd` を付けても、同じ設定でビルドできます。

### エンジン確認用サンプルをビルドする

```sh
latexmk -lualatex src/hello.tex
```

`hello.tex` は、現在のビルドで何のエンジンが使われているかを簡単に確認するためのファイルです。
このファイルは同梱サンプルで、元になっている資料は zr_tex8r 氏の Gist
[`LaTeX: Which kind of "LaTeX" am I using?`](https://gist.github.com/zr-tex8r/27bc6ddf376d4f716e7276c7dad5ec75)
です。教材本文では詳細な出典説明を増やさず、ファイル自身とこの利用ガイド側で由来を追えるようにしています。

### 教材本体をビルドする

```sh
latexmk -lualatex src/introduction-latex.tex
```

PDF は `pdf/`、補助ファイルは `latex.out/` に出力されます。

## 参考文献

この教材では `biblatex + biber` を使います。
文献データは `bib/references.bib` にあり、本文側ではその `.bib` ファイルを読み込みます。

通常は `latexmk` を使えば、必要に応じて `biber` も実行されます。

## 参照まわりの補足

基本の相互参照は `\label` + `\ref` / `\eqref` + `hyperref` です。
より高度な参照管理が必要になった場合は、本文でも触れている `zref` 系 package を発展候補として検討できます。

## VSCode

`.vscode/settings.json` に LaTeX Workshop 用の設定を置いています。
VSCode でもターミナルでも `latexmk` を使う前提にそろえているため、ビルド手順を二重管理しなくて済みます。
LaTeX Workshop では `latex-workshop.latex.build.fromFolder` を `.` に設定し、`src/*.tex` の一つ上、つまりリポジトリルートからレシピを実行します。レシピ側では `-lualatex` と対象ファイルだけを渡し、ビルド内容は `.latexmkrc` に一元化しています。これにより、VSCode からのビルドでも CLI と同じ前提で、PDF は `pdf/`、補助ファイルは `latex.out/` にそろえます。
`.latexmkrc` では既定の TeX Live キャッシュ先が書き込み可能ならそれを使い、書き込めない場合だけ `latex.out/texmfvar` と `latex.out/texmfcache` を使うようにしています。

`.latexmkrc` の見方は次の 2 段です。

- 必須部分: LuaLaTeX の指定、`biblatex + biber` の指定、`pdf/` と `latex.out/` の出力分離、`sty/` と `bib/` を安定して見つけるための `TEXINPUTS` / `BIBINPUTS`
- 環境依存の互換部分: 既定キャッシュ先が書き込めない場合だけ `TEXMFVAR` / `TEXMFCACHE` / `VARTEXMF` を `latex.out/texmf*` に切り替える処理

前回の失敗が残って `gave an error in previous invocation of latexmk` と出る場合は、ソースを直したあとでも再ビルドが走らないことがあります。その場合は `latexmk -g -lualatex src/introduction-latex.tex` を 1 回実行するか、LaTeX Workshop の clean を使って補助ファイルを消してから再ビルドしてください。

## よく触る場所

- 本文を直す: `src/introduction-latex.tex`
- 最小例を直す: `src/minimal.tex`
- エンジン確認サンプルを直す: `src/hello.tex`
- 文献を追加する: `bib/references.bib`
- ビルド設定を直す: `.latexmkrc`
- VSCode 設定を直す: `.vscode/settings.json`

## 運用の前提

- エンジンは LuaLaTeX
- 文書クラスは `jlreq`
- display math は `equation` / `align` 系を使う
- 参考文献は `biblatex + biber`
- PDF は `pdf/`、補助ファイルは `latex.out/` に分離する
