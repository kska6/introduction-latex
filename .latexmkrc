#!/usr/bin/env perl

use warnings;

use Cwd qw(abs_path);
use File::Path qw(make_path);

$latex_base = 'texfot lualatex -synctex=0 -file-line-error -halt-on-error %O %S';
$latex = $latex_base;
$lualatex = $latex_base;
$bibtex_use = 2;
$biber = 'texfot biber %O %S';
$makeindex = 'mendex %O -o %D %S';
$max_repeat = 8;
$pdf_mode = 4;
$pvc_view_file_via_temporary = 0;
$normalize_names = 0;
if ( $^O eq 'darwin' ) {
  $pdf_previewer = 'open %S';
}
elsif ( $^O eq 'MSWin32' ) {
  $pdf_previewer = 'start %S';
}

$project_root = abs_path('.');
$path_sep = ( $^O eq 'MSWin32' ) ? ';' : ':';
$pdf_dir_name = 'pdf';
$aux_dir_name = 'latex.out';

$out_root = "$project_root/$pdf_dir_name";
$aux_root = "$project_root/$aux_dir_name";
$local_texmf_var = "$aux_root/texmfvar";
$local_texmf_cache = "$aux_root/texmfcache";

$out_dir = $out_root;
$emulate_aux = 1;
$aux_dir = $aux_root;

for my $dir ( $out_root, $aux_root, $local_texmf_var, $local_texmf_cache ) {
  ensure_dir_exists($dir);
}

$ENV{'TEXINPUTS'} =
  "$project_root//$path_sep" . ( defined $ENV{'TEXINPUTS'} ? $ENV{'TEXINPUTS'} : '' );
$ENV{'BIBINPUTS'} =
  "$project_root/bib//$path_sep" . ( defined $ENV{'BIBINPUTS'} ? $ENV{'BIBINPUTS'} : '' );

$cache_mode = 'system';
# Fall back to a project-local cache only when the default TeX Live cache is
# not writable. One common reason is sandboxed execution, where paths outside
# this repository may be read-only.
if ( !default_cache_writable() ) {
  $cache_mode = 'project-local';
  $ENV{'TEXMFVAR'} = $local_texmf_var;
  $ENV{'TEXMFCACHE'} = $local_texmf_cache;
  $ENV{'VARTEXMF'} = $local_texmf_var;
  $latex = tex_with_env_prefix($latex_base);
  $lualatex = tex_with_env_prefix($latex_base);
  $biber = tex_with_env_prefix($biber);
}

emit_cache_status(
  cache_mode         => $cache_mode,
  local_texmf_var   => $local_texmf_var,
  local_texmf_cache => $local_texmf_cache,
);

sub ensure_dir_exists {
  my ($path) = @_;
  return 1 if -d $path;

  my $errors = [];
  make_path( $path, { error => \$errors } );
  return 0 if @{$errors};
  return -d $path ? 1 : 0;
}

sub emit_cache_status {
  my (%args) = @_;
  warn "cache mode: $args{cache_mode}\n";
  warn "cache fallback: " . ( $args{cache_mode} eq 'system' ? "disabled\n" : "enabled\n" );
  warn "local cache: $args{local_texmf_var}\n";
  warn "local cache root: $args{local_texmf_cache}\n";
}

sub default_cache_writable {
  my ( $texmfvar, $var_error ) = kpsewhich_var('TEXMFVAR');
  return 0 if $var_error || !first_writable_path($texmfvar);

  my ( $texmfcache, $cache_error ) = kpsewhich_var('TEXMFCACHE');
  return 0 if $cache_error || !first_writable_path($texmfcache);

  return 1;
}

sub kpsewhich_var {
  my ($name) = @_;
  my $output = `kpsewhich -var-value=$name 2>/dev/null`;
  my $status = $? >> 8;
  chomp $output;

  return ( '', 'command failed' ) if $status != 0;
  return ( '', 'empty value' ) if $output eq '';
  return ( $output, '' );
}

sub split_path_list {
  my ($value) = @_;
  return () unless defined $value && $value ne '';
  return grep { defined $_ && $_ ne '' } split /\Q$path_sep\E/, $value;
}

sub first_writable_path {
  my ($value) = @_;
  for my $path ( split_path_list($value) ) {
    return $path if is_writable_dir($path);
  }
  return '';
}

sub is_writable_dir {
  my ($path) = @_;
  return 0 unless defined $path && $path ne '';
  return 0 unless -d $path;

  my $probe = "$path/.latexmk-write-test-$$-" . time();
  if ( open( my $fh, '>', $probe ) ) {
    close $fh;
    unlink $probe;
    return 1;
  }
  return 0;
}

sub shell_quote {
  my ($value) = @_;
  $value =~ s/'/'"'"'/g;
  return "'$value'";
}

sub tex_with_env_prefix {
  my ($command) = @_;
  return join(
    ' ',
    'env',
    'TEXMFVAR=' . shell_quote($local_texmf_var),
    'TEXMFCACHE=' . shell_quote($local_texmf_cache),
    'VARTEXMF=' . shell_quote($local_texmf_var),
    $command,
  );
}
