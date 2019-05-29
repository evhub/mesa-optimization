%Filename: miri-tech-article.cls
% This style is inspired by the AAAI style
\ProvidesClass{miri-tech-article}[2016/11/16 Article for Machine Intelligence Research Institute]
\LoadClass[letterpaper]{article}

% Input encoding
\usepackage{ifluatex}

\ifluatex % LuaTeX
  \usepackage[no-math]{fontspec}
  \defaultfontfeatures{Ligatures=Common}
\else % pdfTeX
  \usepackage[utf8]{inputenc}
\fi

% Initial Packages
\usepackage{graphicx}
\def\pdfshellescape{1}
\usepackage{epstopdf}
\usepackage{accsupp}
\usepackage[absolute]{textpos}

% Document Class Options
%% toc - display the table of contents
\newif\if@toc
\@tocfalse
\DeclareOption{toc}{\@toctrue}

% is this an annotated bibliography?
\newif\if@annote
\@annotefalse
\DeclareOption{annote}{\@annotetrue}

% use only one column?
\newif\if@onecolumn
\@onecolumnfalse
\DeclareOption{onecolumn}{\@onecolumntrue}

% suppress page numbers using 'nopagenum'?
\newif\if@nopagenum
\@nopagenumfalse
\DeclareOption{nopagenum}{\@nopagenumtrue}

% if for some reason we really need to use Natbib
\newif\if@natbib
\@natbibfalse
\DeclareOption{natbib}{\@natbibtrue}

% Use author-date citations (Name-Year)
%%% NOTE: this is enabled by default, but added as an option to support older papers that call the option
\newif\if@authordate
\@authordatefalse
\DeclareOption{authordate}{\@authordatetrue}

% Use numeric citations [#]
\newif\if@numeric
\@numericfalse
\DeclareOption{numeric}{\@numerictrue}

% use compressed version of numeric citation; displays multiples as a range, e.g., [1-4] rather than [1][2[3][4]
\newif\if@numericcomp
\@numericcompfalse
\DeclareOption{numericcomp}{\@numericcomptrue}

% Use authblk package to add many authors/institutions and override the current author format
\newif\if@authblk
\@authblkfalse
\DeclareOption{authblk}{\@authblktrue}

\ProcessOptions\relax

\if@annote
	\PassOptionsToPackage{annotation}{biblatex-chicago}
	\PassOptionsToPackage{sorting=none}{biblatex-chicago}
\fi


% Bibliography

\if@natbib
\usepackage[round,sort&compress]{natbib}
\else
  \if@numeric
  \usepackage[backend=biber,natbib=true,style=numeric,citestyle=numeric,sorting=none]{biblatex}
  \else
    \if@numericcomp
    \usepackage[backend=biber,natbib=true,style=numeric,citestyle=numeric-comp,sorting=none]{biblatex}
    \else
      \if@authordate
      \usepackage[authordate,natbib,backend=biber,noibid]{biblatex-chicago}
      \else
        \usepackage[authordate,natbib,backend=biber,noibid]{biblatex-chicago}
      \fi
    \fi
  \fi
  % fix long URLs displaying incorrectly on arXiv.org > http://tex.stackexchange.com/questions/134191/line-breaks-of-long-urls-in-bibliography :
  \setcounter{biburllcpenalty}{7000}
  \setcounter{biburlucpenalty}{8000}
\fi

\renewcommand{\bibfont}{\footnotesize}


% Ensure header and footnotes are not copyable
\let\oldthepage\thepage
\DeclareRobustCommand\squelch[1]{%
    \BeginAccSupp{method=plain,ActualText={}}#1\EndAccSupp{}}

% Smaller margins
\usepackage[top=1.25in, left=1.25in, bottom=1.25in, right=1.25in]{geometry}
%\setlength{\textheight}{10.2in}

% Footnotes
\setlength{\skip\footins}{1cm}
\setlength{\footnotesep}{.5cm}
\renewcommand{\footnotesize}{\fontsize{10pt}{14pt}\selectfont}

% Text-mode Superscript and Subscript
\newcommand\textexp[1]{$^\text{#1}$}
\newcommand\textsub[1]{$_\text{#1}$}

% Links
\usepackage[unicode,bookmarks=true,bookmarksnumbered=true,breaklinks=true]{hyperref}
\usepackage[usenames,dvipsnames]{xcolor}
\definecolor{miriblue}{RGB}{66,70,117}
\AtBeginDocument{
  \hypersetup{
	%colorlinks=false,
	urlbordercolor=miriblue,
	linkbordercolor=lightgray,
	pdfborderstyle={/S/U/W 1},
	linktoc=page,
	citecolor=black,
	linkcolor=black,
	urlcolor=miriblue
  }
}

% PHYSICAL PAGE LAYOUT
\setlength\topmargin{-0.25in} \setlength\oddsidemargin{-0.25in}
\setlength\textheight{9.0in} \setlength\textwidth{7.0in}
\setlength\columnsep{0.375in} \newlength\titlebox \setlength\titlebox{2.25in}
\setlength\headheight{0pt}  \setlength\headsep{0pt}

% supress page numbers if needed
\if@nopagenum
  \thispagestyle{empty} \pagestyle{empty}
\else
  \thispagestyle{plain} \pagestyle{plain}
\fi

\flushbottom \twocolumn \sloppy

% fix margins if only using one column
\if@onecolumn
  \setlength\textwidth{5.0in}
  \setlength\oddsidemargin{0.75in}
\fi

% PRINT FIRST-PAGE NOTICE
% - This used to be for a copyright declaration, but that has been replaced by a generic footer slug
\def\copyright@year{\number\year}
\def\copyright@text{Research supported by the Machine Intelligence Research Institute (intelligence.org).}
\def\copyright@on{T}
\def\nocopyright{\gdef\copyright@on{}}
\def\copyrighttext#1{\gdef\copyright@on{T}\gdef\copyright@text{#1}}
\def\publishingnote#1{\gdef\copyright@on{T}\gdef\copyright@text{Research supported by the Machine Intelligence Research Institute (intelligence.org). #1}}
\def\copyrightyear#1{\gdef\copyright@on{T}\gdef\copyright@year{#1}}
\def\customnote#1{\gdef\copyright@on{T}\gdef\copyright@text{#1}}
% gf: End changes for copyright notice (used in \maketitle, below)

% Title stuff, taken from deproc.
\def\maketitle{\par
\begingroup % to make the footnote style local to the title
\def\thefootnote{\fnsymbol{footnote}}
\if@onecolumn
	\onecolumn
	\@maketitle
	\@thanks
\else
  \twocolumn[\@maketitle] \@thanks
\fi
\endgroup
% Insert first-page copyright slug unless turned off
\if T\copyright@on\insert\footins{\noindent\footnotesize\copyright@text}\fi
% gf: And now back to your regular programming
\setcounter{footnote}{0}

\let\maketitle\relax \let\@maketitle\relax
\gdef\@thanks{}\gdef\@author{}\gdef\@title{}\gdef\@date{}\let\thanks\relax}

%Option for many authors - toggles between standard author markup and authblk package.
\if@authblk
  \usepackage[noblocks]{authblk}
  \renewcommand\Authfont{\normalsize\bf}
  \renewcommand\Affilfont{\small\rm}
  \setlength{\affilsep}{5pt}
  \renewcommand\Authands{, \rm{and} }
    \def\@maketitle{\vbox to \titlebox{\hsize\textwidth
    \linewidth\hsize \vskip 0.625in minus 0.125in \centering
    {\Large\bf \@title \par} \vskip 0.2in plus 1fil minus 0.1in
    {\@author \par}
    \vskip 0.15in plus 1fil minus 0.125in
    {\small\@date}
    \vskip 0.3in plus 2fil minus 0.1in
    }
    \if@toc
      \centering\begin{minipage}[]{5in}\tableofcontents\end{minipage}
      \vskip 0.7in plus 2fil minus 0.1in
    \fi
    }

\else

    \def\@maketitle{\vbox to \titlebox{\hsize\textwidth
    \linewidth\hsize \vskip 0.625in minus 0.125in \centering

    {\Large\bf \@title \par} \vskip 0.2in plus 1fil minus 0.1in
    {\def\and{\unskip\enspace{\rm and}\enspace}
    \def\And{\end{tabular}\hss \egroup \hskip 1in plus 2fil
     \hbox to 0pt\bgroup\hss \begin{tabular}[t]{c}\normalsize\bf}
    \def\AND{\end{tabular}\hss\egroup \hfil\hfil\egroup
    \vskip 0.25in plus 1fil minus 0.125in

     \hbox to \linewidth\bgroup\small \hfil\hfil
    \hbox to 0pt\bgroup\hss \begin{tabular}[t]{c}\normalsize\bf}
    \hbox to \linewidth\bgroup\small \hfil\hfil
    \hbox to 0pt\bgroup\hss \begin{tabular}[t]{c}\normalsize\bf\@author \par
    \end{tabular}\hss\egroup
    \hfil\hfil\egroup}
    \vskip 0.15in plus 1fil minus 0.125in
    {\small\@date}
    \vskip 0.3in plus 2fil minus 0.1in
    }
    \if@toc
      \centering\begin{minipage}[]{5in}\tableofcontents\end{minipage}
      \vskip 0.7in plus 2fil minus 0.1in
    \fi
    }
\fi
  \global\let\@date\@empty

%End of title/author stuff

\renewenvironment{abstract}{\centerline{\bf
Abstract}\vspace{0.5ex}\begin{quote}\small}{\par\end{quote}\vskip 1ex}
% jsp added:
\def\pubnote#1{\thispagestyle{myheadings}
\pagestyle{myheadings}
\markboth{#1}{#1}
\setlength\headheight{10pt}  \setlength\headsep{10pt}
}

\setcounter{secnumdepth}{0}

% FOOTNOTES
\footnotesep 6.65pt %
\skip\footins 9pt plus 4pt minus 2pt
\def\footnoterule{\kern-3pt \hrule width 5pc \kern 2.6pt }
\setcounter{footnote}{0}

%% LISTS AND PARAGRAPHS
% Less leading in most fonts (due to the narrow columns)
% The choices were between 1-pt and 1.5-pt leading
\def\normalsize{\@setfontsize\normalsize\@xpt{11}}   % 10 point on 11
\def\small{\@setfontsize\small\@ixpt{10}}    % 9 point on 10
\def\footnotesize{\@setfontsize\footnotesize\@ixpt{10}}  % 9 point on 10
\def\scriptsize{\@setfontsize\scriptsize\@viipt{10}}  % 7 point on 8
\def\tiny{\@setfontsize\tiny\@vipt{7}}    % 6 point on 7
\def\large{\@setfontsize\large\@xipt{12}}    % 11 point on 12
\def\Large{\@setfontsize\Large\@xiipt{14}}    % 12 point on 14
\def\LARGE{\@setfontsize\LARGE\@xivpt{16}}    % 14 point on 16
\def\huge{\@setfontsize\huge\@xviipt{20}}    % 17 point on 20
\def\Huge{\@setfontsize\Huge\@xxpt{23}}    % 20 point on 23

%Don't go around inserting vertical space between stuff, for crying out loud.
\raggedbottom
