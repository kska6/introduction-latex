#!/usr/bin/env perl

# defaults: LuaLaTeX + biber

use Cwd qw(abs_path);

$do_cd = 1;
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

$ENV{'TEXINPUTS'} = './/:' . (defined $ENV{'TEXINPUTS'} ? $ENV{'TEXINPUTS'} : '');
$ENV{'TEXMFVAR'} = "$aux_root/texmfvar";
$ENV{'TEXMFCACHE'} = "$aux_root/texmf-cache";

$out_dir = $out_root;
$emulate_aux = 1;
$aux_dir = $aux_root;
