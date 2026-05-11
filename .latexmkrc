#!/usr/bin/env perl

# defaults: LuaLaTeX + biber

use Cwd qw(abs_path);
use File::Path qw(make_path);

# Required part:
# - use LuaLaTeX
# - use biber for biblatex
# - place PDFs in out/ and auxiliary files in out/aux/
# - resolve sty/ and bib/ consistently from the repository root
$latex = 'texfot lualatex -synctex=0 -file-line-error -halt-on-error %O %S';
$lualatex = 'texfot lualatex -synctex=0 -file-line-error -halt-on-error %O %S';
$bibtex_use = 2;
$biber = 'texfot biber %O %S';
$makeindex = 'mendex %O -o %D %S';
$max_repeat = 8;
$pdf_mode = 4;
$pvc_view_file_via_temporary = 0;
if ( $^O eq 'darwin' ) {
  $pdf_previewer = 'open %S';
}

$project_root = abs_path('.');
$out_root = "$project_root/out";
$aux_root = "$out_root/aux";
$path_sep = ( $^O eq 'MSWin32' ) ? ';' : ':';

# Sandbox-only part:
# The variables below are not generally required for LuaLaTeX itself.
# They exist because sandboxed execution may not be allowed to write to the
# TeX Live default cache directories outside this repository.
$cache_root_abs = "$aux_root/texmf-cache";
$cache_var_abs = "$aux_root/texmfvar";
$cache_root_rel = "out/aux/texmf-cache";
$cache_var_rel = "out/aux/texmfvar";
$cache_root_from_src = "../out/aux/texmf-cache";
$cache_var_from_src = "../out/aux/texmfvar";

# Search from the repository root so builds work whether latexmk runs in
# the root directory or changes into src/.
$ENV{'TEXINPUTS'} =
  "$project_root//$path_sep" . (defined $ENV{'TEXINPUTS'} ? $ENV{'TEXINPUTS'} : '');
$ENV{'BIBINPUTS'} =
  "$project_root/bib//$path_sep" . (defined $ENV{'BIBINPUTS'} ? $ENV{'BIBINPUTS'} : '');

# Sandbox-only cache overrides.
$ENV{'TEXMFVAR'} =
  join($path_sep, $cache_var_abs, $cache_var_rel, $cache_var_from_src);
$ENV{'TEXMFCACHE'} =
  join($path_sep, $cache_root_abs, $cache_root_rel, $cache_root_from_src);
$ENV{'VARTEXMF'} = $ENV{'TEXMFVAR'};

# Sandbox-only directory bootstrap.
for my $dir ( $out_root, $aux_root, $cache_var_abs, $cache_root_abs ) {
  make_path($dir) unless -d $dir;
}

# Required output split.
$out_dir = $out_root;
$emulate_aux = 1;
$aux_dir = $aux_root;
