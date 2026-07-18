% ucithesis.cls: LaTeX class for writing a UCI thesis or dissertation,
%   based on the LaTeX ``report'' class, to comply with the ``UCI Thesis
%   and Dissertation Manual'' (https://guides.lib.uci.edu/gradmanual/home).
%
% Derived from the previous uci-thesis-latex template
%   (https://github.com/lotten/uci-thesis-latex). Credits are in the README.
%
% Disclaimer: provided without any guarantees.
%
% Changelog:
% Jul 17, 2026: Rewrote the class for PDF/UA-2 accessibility tagging via the
%               LaTeX tagging project (tagged title page, headings, TOC/LOF/
%               LOT, chapters, tables, and bibliography). Updated the template 
%               to adhere to the updated UCI thesis manual. Requires TeX Live
%               2025+ and LuaLaTeX. Renamed \documenttitle -> \documenttype.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ucithesis}[2026/07/17 UCI Thesis class]

\LoadClassWithOptions{report}
\RequirePackage[hmargin={1in,1in},vmargin={1in,1in}]{geometry}
\RequirePackage{setspace}


\AddToHook{begindocument/end}{%
  \tagpdfparaOff
}

% Override \phantomsection to use the LaTeX kernel's modern
% \MakeLinkTarget mechanism. \MakeLinkTarget[section]{} creates a
% section-style destination that integrates with latex-lab's tagging
% system, so it auto-links to the next opened structure (avoiding the
% "Destination has no related structure" warning).
\AtBeginDocument{%
  \renewcommand\phantomsection{\MakeLinkTarget[section]{}}%
  % Re-apply latex-lab-float's \caption definition (the caption package,
  % loaded after the float module, overwrote it with one that fires
  % hyperref's caption auto-anchor and creates orphan
  % "figure.caption.N" destinations). This version uses
  % \@kernel@refstepcounter (no auto-anchor) and points
  % \@currentHref at the float's \MakeLinkTarget* anchor.
  \def\caption{%
     \ifx\@captype\@undefined
       \@latex@error{\noexpand\caption\space outside float}\@ehd
       \expandafter\@gobble
     \else
       \ifx\@current@float@struct\@empty
         \refstepcounter\@captype
       \else
         \@kernel@refstepcounter\@captype
         \xdef\@currentHref{\@captype.struct.\@current@float@struct}%
       \fi
       \expandafter\@firstofone
     \fi
     {\@dblarg{\@caption\@captype}}%
  }%
}

% Store the thesis title as plain text. Applying \MakeUppercase here
 % bakes the optional-argument syntax into \Thesistitle, which leaks
 % "[]" when written to PDF metadata / XMP. Apply \MakeUppercase only
 % at render time (see the Title structure tag below).
 \newcommand{\thesistitle}[1]{\newcommand\Thesistitle{#1}}
\newcommand{\documenttype}[1]{\newcommand\Documenttype{#1}} % this is "dissertation" or "MS Thesis" ...
\newcommand{\degreename}[1]{\newcommand\Degreename{#1}}
\newcommand{\degreefield}[1]{\newcommand\Degreefield{#1}}
\newcommand{\authorname}[1]{\newcommand\Authorname{#1}}
\newcommand{\degreeyear}[1]{\newcommand\Degreeyear{#1}}
\newcommand{\committeechair}[1]{\newcommand\Committeechair{#1}}
\newcommand{\othercommitteemembers}[1]{\newcommand\Othercommitteemembers{#1}}
\newcommand{\copyrightdeclaration}[1]{\newcommand\Copyrightdeclaration{#1}}
\newcommand{\dedications}[1]{\newcommand\Dedications{#1}}
\newcommand{\acknowledgments}[1]{\newcommand\Acknowledgments{#1}}
\newcommand{\curriculumvitae}[1]{\newcommand\Curriculumvitae{#1}}
\newcommand{\thesisabstract}[1]{\newcommand\Thesisabstract{#1}}
\newcommand{\bibliographyname}[1]{\renewcommand{\bibname}{#1}}

\newcounter{prelimsection}
\newcounter{prelimsubsection}[prelimsection]
% Counter used to allocate destinations for non-chapter preliminary headings
% (TOC, LOF, LOT, ACK, VITA, ABSTRACT, Bibliography). Using \refstepcounter
% on this — instead of \phantomsection — produces a destination that
% tagpdf can link to a manually-opened structure (avoids the 
% "Destination has no related structure" warning).      
\newcounter{ucipreliminarydest}     

\newcommand{\thesistitlepage}
{
    \vspace*{0.5in}
	\thispagestyle{empty}
	\singlespacing
    \pdfbookmark[0]{Title}{titlepage}%
	\tagpdfparaOff
	% Open a chapter-level <Sect> for the title page so the <Title>
	% and the surrounding <P>s nest under one container in the tag tree.
	\tagstructbegin{tag=Sect}%
	\uci@chap@sect@opentrue
	\begin{center}
		\tagstructbegin{tag=P}
		\tagmcbegin{tag=P}
		  UNIVERSITY OF CALIFORNIA, \\
		  IRVINE \\
		\tagmcend
		\tagstructend
		\vspace{0.4in}
		% Tag the thesis title with the PDF 2.0 <Title> structure type.
		% This is the document title -- there is only one of these,
		% distinct from any heading level.
		\tagstructbegin{tag=Title}
		\tagmcbegin{tag=Title}
		  \MakeUppercase{\Thesistitle} \\
		\tagmcend
		\tagstructend
		\vspace{0.15in}
        %"Dissertation" for PhD, "Thesis" for master's
        \tagstructbegin{tag=P}
		\tagmcbegin{tag=P}
		  \MakeUppercase{\Documenttype} \\
		\vspace{0.4in}
		submitted in partial satisfaction of the requirements \\
		for the degree of \\
		\vspace{0.4in}
		\MakeUppercase{\Degreename} \\
		\vspace{0.15in}
		in \Degreefield \\
		\vspace{0.4in}
		by \\
		\vspace{0.4in}
		\Authorname \\
		\tagmcend
		\tagstructend
	\end{center}
    \vspace{1in}
    \begin{flushright}
            \tagstructbegin{tag=P}
            \tagmcbegin{tag=P}
            \Documenttype \;Committee: \\
            \Committeechair, Chair \\
            \Othercommitteemembers \\
            \tagmcend
            \tagstructend
    \end{flushright}
    \vfill
    \begin{center}
        \tagstructbegin{tag=P}
        \tagmcbegin{tag=P}
            \Degreeyear
        \tagmcend
        \tagstructend
    \end{center}
	\tagpdfparaOn
	\clearpage
}

\newcommand{\copyrightpage}
{
    \thispagestyle{empty}
    \rule{0in}{0in}
    \protect\vfill
    \begin{center}
        \Copyrightdeclaration
    \end{center}
    \clearpage
}

\newcommand{\signaturepage}
{
    \vspace*{1in} 
    \begin{center}    
        The \MakeLowercase{\Documenttype} of \Authorname \\
        is approved and is acceptable in quality and form for \\
        publication on microfilm and in digital formats: \\
    \end{center}                          
    \vspace{3in}                              
    \begin{flushright}
    \rule{3in}{0.01in} \\                      
    \vspace{0.4in} 
    \rule{3in}{0.01in} \\                     
    \vspace{0.4in} 
    \rule{3in}{0.01in} \\                      
    Committee Chair 
    \end{flushright}                 
    \vspace{.75in}
    \begin{center}  
    University of California, Irvine \\  
    \Degreeyear 
    \end{center}
    \clearpage
}

% Define prelimsection - use H1 since title is <Title>
\newcommand{\prelimsection}[1]{%
    % Close the previous chapter-level <Sect> wrapper, if open.
    \ifuci@chap@sect@open
      \tagstructend%
      \uci@chap@sect@openfalse
    \fi
    \tagpdfparaOff%
    % Open this prelim section's <Sect> wrapper containing the H1
    % and any following content.
    \tagstructbegin{tag=Sect}%
    \uci@chap@sect@opentrue
    \tagstructbegin{tag=H1}%
    \tagmcbegin{tag=H1}%
    {\centerline{\Large\textbf{#1}}}%
    \tagmcend%
    \tagstructend%
    \vspace{1ex}%
}

% Define prelimsubsection as H2
\newcommand{\prelimsubsection}[1]{%
    \par% close any open paragraph from previous content so the
        % auto-tagger fires the matching end-hook before we toggle
        % \tagpdfparaOff (otherwise begin/end counts go out of sync)
    \vspace{10pt}
    \tagpdfparaOff%
    \tagstructbegin{tag=H2}%
    \tagmcbegin{tag=H2}%
    {\normalsize\textbf{#1}\par}%
    \tagmcend%
    \tagstructend%
    \tagpdfparaOn%
    \vspace{-1.5ex}%
}

\newcommand{\dedicationpage}
{
	\clearpage
    \pdfbookmark[0]{Dedication}{dedicationpage}%
	\prelimsection{DEDICATION}
	\vspace{0.4in}
	\tagstructbegin{tag=P}
	\tagmcbegin{tag=P}
	{\centering\Dedications\par}
	\tagmcend
	\tagstructend
	\clearpage
}

\newcommand{\acknowledgmentspage}
{
	\clearpage
	\prelimsection{ACKNOWLEDGMENTS}
	\parskip 12pt
	\parindent 0pt
	\tagpdfparaOn
	\Acknowledgments
	\par% force-close the last paragraph (text-unit) before \tagpdfparaOff.
	    % Without this, if the \Acknowledgments content doesn't end in
	    % an explicit \par/blank line, \tagpdfparaOff fires mid-paragraph
	    % and leaves the text-unit open, causing subsequent prelim pages
	    % and chapters to nest inside it.
	\tagpdfparaOff
	\clearpage
}

\newcommand{\curriculumvitaepage}{
	\clearpage
	\prelimsection{VITA}
	\vspace{0.2in}
	\tagstructbegin{tag=P}
	\tagmcbegin{tag=P}
	{\centering\textbf{\large \Authorname}\par}
	\tagmcend
	\tagstructend
	%\tagpdfparaOn
	%\vspace{0.2in}
	\Curriculumvitae
	\clearpage
}

\newcommand{\abstractpage}
{
	\clearpage
	\prelimsection{ABSTRACT OF THE \MakeUppercase{\Documenttype}} 
	\vspace{0.2in}
	\tagstructbegin{tag=P}
	\tagmcbegin{tag=P}
	{
        \centering
	\Thesistitle \par
	\vspace{0.1in}
	By \par
	\vspace{0.1in}
	\Authorname \par
	\vspace{0.1in}
	\Degreename\ in \Degreefield \par
	%\vspace{0.1in}
	University of California, Irvine, \Degreeyear \par
	%\vspace{0.1in}
	\Committeechair, Chair \par
	}
	\tagmcend
	\tagstructend
	\tagpdfparaOn
	\vspace{0.2in}
	\doublespacing
	\Thesisabstract
	\clearpage
}


%%%% the key was explicitly closing the TOC structure that latex-lab automatically creates when \@starttoc is called. By adding \tagstructend right after each \@starttoc{toc}, \@starttoc{lof}, and \@starttoc{lot}, you force-closed those structures instead of relying on automatic closure.
%%%%This prevented all subsequent content (like ACKNOWLEDGMENTS, ABSTRACT, chapters, etc.) from getting nested inside the TOC structure in the PDF's tag tree.

% Fix the TOC/LOF/LOT names
\renewcommand{\contentsname}{TABLE OF CONTENTS}
\renewcommand{\listfigurename}{LIST OF FIGURES}
\renewcommand{\listtablename}{LIST OF TABLES}

% Redefine tableofcontents - explicitly close the TOC structure
\renewcommand{\tableofcontents}{%
  \clearpage
  \pdfbookmark[0]{Table of Contents}{tocpage}%
  % Close the previous chapter-level <Sect> wrapper, if open.
  \ifuci@chap@sect@open
    \tagstructend%
    \uci@chap@sect@openfalse
  \fi
  \tagpdfparaOff%
  % Open this prelim section's <Sect> wrapper.
  \tagstructbegin{tag=Sect}%
  \uci@chap@sect@opentrue
  \tagstructbegin{tag=H1}%
  \tagmcbegin{tag=H1}%
  {\centerline{\Large\textbf{\contentsname}}}%
  \tagmcend%
  \tagstructend%
  \vspace{40pt}%
  \@starttoc{toc}%
  \tagstructend% Explicitly close the TOC structure created by latex-lab
}

  \renewcommand{\listoffigures}{%
    \clearpage
    \phantomsection
    \addcontentsline{toc}{chapter}{LIST OF FIGURES}
    % Close the previous chapter-level <Sect> wrapper, if open.
    \ifuci@chap@sect@open
      \tagstructend%
      \uci@chap@sect@openfalse
    \fi
    \tagpdfparaOff%
    % Open this prelim section's <Sect> wrapper.
    \tagstructbegin{tag=Sect}%
    \uci@chap@sect@opentrue
    \tagstructbegin{tag=H1}%
    \tagmcbegin{tag=H1}%
    {\centerline{\Large\textbf{\listfigurename}}}%
    \tagmcend%
    \tagstructend%
    \vspace{40pt}%
    \@starttoc{lof}%
    \tagstructend% Explicitly close the LOF structure
}

\renewcommand{\listoftables}{%
  \clearpage
  \phantomsection
  \addcontentsline{toc}{chapter}{LIST OF TABLES}
  % Close the previous chapter-level <Sect> wrapper, if open.
  \ifuci@chap@sect@open
    \tagstructend%
    \uci@chap@sect@openfalse
  \fi
  \tagpdfparaOff%
  % Open this prelim section's <Sect> wrapper.
  \tagstructbegin{tag=Sect}%
  \uci@chap@sect@opentrue
  \tagstructbegin{tag=H1}%
  \tagmcbegin{tag=H1}%
  {\centering\Large\textbf{\listtablename}\par}%
  \tagmcend%
  \tagstructend%
  \vspace{40pt}%
  \@starttoc{lot}%
  \tagstructend% Explicitly close the LOT structure
}

% Add "Page" as column title to Table of Contents, List of Figures,
% List of Tables, and List of Algorithms
\addtocontents{toc}{{\protect\flushright Page\par}}
\addtocontents{lof}{{\protect\flushright Page\par}}
\addtocontents{lot}{{\protect\flushright Page\par}}
\addtocontents{loa}{{\protect\flushright Page\par}}

\newcommand{\preliminarypages}
{
	\pagenumbering{gobble}
	\clearpage
	\thispagestyle{empty}
	\thesistitlepage
	\clearpage
	\pagenumbering{roman}
    \copyrightpage
	\setcounter{page}{2}
	\ifx\Dedications\undefined
	\else
	  \dedicationpage
	\fi
	\tableofcontents
	\listoffigures
	\listoftables
	% In \preliminarypages, after LIST OF TABLES:
\ifx\listalgorithmname\undefined
\else
  \clearpage
  \phantomsection
  \addcontentsline{toc}{chapter}{LIST OF ALGORITHMS}
  \tagpdfparaOff%
  \vspace*{50pt}%
  \tagstructbegin{tag=H1}%
  \tagmcbegin{tag=H1}%
  {\centerline{\Large\textbf{LIST OF ALGORITHMS}}}%
  \tagmcend%
  \tagstructend%
  \vspace{40pt}%
  \listofalgorithms
  \tagstructend% Explicitly close the structure
\fi

% Before ACKNOWLEDGMENTS:
% \clearpage BEFORE \addcontentsline so the TOC records the page the
% heading actually appears on (not the previous page).
\clearpage
\phantomsection
\addcontentsline{toc}{chapter}{ACKNOWLEDGMENTS}
\acknowledgmentspage
	\ifx\Curriculumvitae\undefined
	\else
	  \clearpage
	  \phantomsection
	  \addcontentsline{toc}{chapter}{VITA}
	  \curriculumvitaepage
	\fi
	\clearpage
	\phantomsection
	\addcontentsline{toc}{chapter}{ABSTRACT OF THE \texorpdfstring{\MakeUppercase{\Documenttype}}{\Documenttype}}
	\abstractpage
	\clearpage
	\setcounter{page}{1}
	\pagenumbering{arabic}
}

% Reverted back to standard latex appendix, since numbering of
% figures/tables was broken with custom command.
\newcommand{\myappendix}
{
	\clearpage
	\setcounter{section}{0}
	\setcounter{figure}{0}
	\setcounter{table}{0}
	\setcounter{equation}{0}
	\gdef\thechapter{\@Alph\c@section}
	\gdef\thesection{\@Alph\c@section}
	\tagpdfparaOff%
	\tagstructbegin{tag=H1}%
	\tagmcbegin{tag=H1}%
	\chapter*{Appendices}
	\tagmcend%
	\tagstructend%
	%\tagpdfparaOn%
	\addcontentsline{toc}{chapter}{Appendices}
}

% Redefine the bibliography environment to add tagging
\renewenvironment{thebibliography}[1]{%
  \clearpage
  \phantomsection
  \addcontentsline{toc}{chapter}{\bibname}%
  \tagpdfparaOff%
  \vspace*{50pt}%
  \tagstructbegin{tag=H1}%
  \tagmcbegin{tag=H1}%
  {\raggedright\Huge\textbf{\bibname}}% 
  \tagmcend%
  \tagstructend%
  \vspace{40pt}%
  \tagpdfparaOn%
  \begin{singlespacing}%
  \list{\@biblabel{\@arabic\c@enumiv}}%
       {\settowidth\labelwidth{\@biblabel{#1}}%
        \leftmargin\labelwidth
        \advance\leftmargin\labelsep
        \@openbib@code
        \usecounter{enumiv}%
        \let\p@enumiv\@empty
        \renewcommand\theenumiv{\@arabic\c@enumiv}}%
  \sloppy
  \clubpenalty4000
  \@clubpenalty \clubpenalty
  \widowpenalty4000%
  \sfcode`\.\@m%
}{%
  \def\@noitemerr
   {\@latex@warning{Empty `thebibliography' environment}}%
  \endlist
  \end{singlespacing}%
}

% Simplified bibliography command
\renewcommand{\bibliography}[1]{%
  \if@filesw
    \immediate\write\@auxout{\string\bibdata{#1}}%
  \fi
  \@input@{\jobname.bbl}%
}


% Redefine \chapter to use manual H2 tagging (same body as the old
% \HOneChapter wrapper). This gives:
%   - the H2 tag in the PDF tree (consistent with the title page H1)
%   - proper destination linking via \refstepcounter{chapter}, so the
%     "Destination has no related structure" warning does not fire
%   - the standard \chapter{Title} syntax
% Defined as a separate macro then installed via \AtBeginDocument so we
% override latex-lab phase-III's auto-tag patches on \chapter (which
% load after the class file). Using a separate \newcommand keeps the
% parameter syntax simple — no #/## escaping issues inside the hook.
% Two separate chapter macros: one for regular chapters, one for
% appendices. Each uses LITERAL "Chapter " or "Appendix " text in the
% MC content (no inline macro expansion that could split the H2). We
% switch \chapter between them via \appendix.

% Flag tracking whether a chapter-level Sect is currently open.
% Used so each chapter-like macro (\uci@chapter, \uci@appendixchapter,
% \bibsection) can close the previous chapter's Sect before opening
% its own. Without this wrapper, sections within a chapter would be
% siblings of the H1 instead of nested under a chapter <Sect>.
\newif\ifuci@chap@sect@open
\uci@chap@sect@openfalse

\newcommand{\uci@chapter}[1]{%
  \clearpage%
  % Close any open auto-Sect from previous chapter content (sections,
  % subsections, etc.) down to chapter level using latex-lab's public
  % \tagtool API. Then bump the para-end counter for each closed level.
  \par\tagtool{sec-stop=chapter}%
  % Close the previous chapter's manual <Sect> wrapper, if open.
  \ifuci@chap@sect@open
    \tagstructend%
    \uci@chap@sect@openfalse
  \fi
  \refstepcounter{chapter}%
  \addcontentsline{toc}{chapter}{\protect\numberline{\thechapter}#1}%
  \chaptermark{#1}%
  \tagpdfparaOff%
  \thispagestyle{plain}%
  \suppressfloats[t]%
  \vspace*{50pt}%
  % Open a chapter-level <Sect> that will contain the H1 + content.
  % This gives the proper PDF/UA-2 hierarchy: Sect > H1 + body, with
  % nested section <Sect>s as siblings of H1 inside the chapter Sect.
  \tagstructbegin{tag=Sect}%
  \uci@chap@sect@opentrue
  \tagstructbegin{tag=H1,actualtext=\expanded{Chapter \thechapter\space #1}}%
  \tagmcbegin{tag=H1}%
  {\huge\bfseries Chapter \thechapter\par}%
  \vspace{20pt}%
  {\Huge\bfseries #1\par}%
  \tagmcend%
  \tagstructend%
  \vspace{40pt}%
  \tagpdfparaOn%
  \nobreak%
}

\newcommand{\uci@appendixchapter}[1]{%
  \clearpage%
  % Same section-close logic as \uci@chapter for the appendix chapter.
  \par\tagtool{sec-stop=chapter}%
  % Close the previous chapter's manual <Sect> wrapper, if open.
  \ifuci@chap@sect@open
    \tagstructend%
    \uci@chap@sect@openfalse
  \fi
  \refstepcounter{chapter}%
  %%Add "Appendix" before \thechapter to add the word appendix. will need to fix the formatting issue
  \addcontentsline{toc}{chapter}{\protect\numberline{\thechapter}#1}%
  \chaptermark{#1}%
  \tagpdfparaOff%
  \thispagestyle{empty}%
  \suppressfloats[t]%
  \vspace*{80pt}%
  % Open the appendix-chapter <Sect> wrapper.
  \tagstructbegin{tag=Sect}%
  \uci@chap@sect@opentrue
  \tagstructbegin{tag=H1,actualtext=\expanded{Appendix \thechapter\space #1}}%
  \tagmcbegin{tag=H1}%
  {\leftline{\huge\bfseries Appendix \thechapter}}%
  \vspace{60pt}%
  {\leftline{\Huge\bfseries #1}}%
  \tagmcend%
  \tagstructend%
  \vspace{40pt}%
  \tagpdfparaOn%
  \nobreak%
}

% Helper strings for \addcontentsline filtering inside \appendix.
\def\uci@lofstr{lof}
\def\uci@lotstr{lot}

\AtBeginDocument{%
  \let\chapter\uci@chapter
  % Override \appendix in the same hook so it fires AFTER the
  % auto-tagger has patched \appendix and \chapter.
  \let\uci@origappendix\appendix
  \renewcommand{\appendix}{%
    \uci@origappendix
    \let\chapter\uci@appendixchapter
    % Suppress LOF/LOT entries for appendix floats. UCI thesis manual
    % requires that appendix figures/tables not appear in LOF/LOT.
    % This override (instead of \captionsetup{list=no}) keeps the
    % toc writes (chapter/section) intact.
    \def\uci@lofstr{lof}%
    \def\uci@lotstr{lot}%
    \let\uci@orig@addcontentsline\addcontentsline
    \renewcommand{\addcontentsline}[3]{%
      \edef\uci@acl@file{##1}%
      \ifx\uci@acl@file\uci@lofstr
      \else
        \ifx\uci@acl@file\uci@lotstr
        \else
          \uci@orig@addcontentsline{##1}{##2}{##3}%
        \fi
      \fi
    }%
  }%
}

% Close the last open chapter Sect at end-of-document so the structure
% stack is balanced. The flag prevents a duplicate close if some other
% mechanism already closed it.
\AtEndDocument{%
  \ifuci@chap@sect@open
    \tagstructend%
    \uci@chap@sect@openfalse
  \fi
}



% natbib (loaded in thesis.tex) redefines \thebibliography and uses
% \bibsection for the heading. Override \bibsection at begin-document
% (after natbib has loaded) so we get our manual H2 instead of natbib's
% \chapter*{\bibname \@mkboth{...}{...}} which leaks raw command text
% into the auto-tagged heading.
\AtBeginDocument{%
  \@ifpackageloaded{natbib}{%
    \renewcommand\bibsection{%
      \clearpage
      % Close any open auto-Sect from the previous chapter.
      \par\tagtool{sec-stop=chapter}%
      % Close the previous chapter's manual <Sect> wrapper, if open.
      \ifuci@chap@sect@open
        \tagstructend%
        \uci@chap@sect@openfalse
      \fi
      \phantomsection
      \addcontentsline{toc}{chapter}{\bibname}%
      \tagpdfparaOff%
      \vspace*{80pt}%
      % Open the bibliography's chapter-level <Sect> wrapper.
      \tagstructbegin{tag=Sect}%
      \uci@chap@sect@opentrue
      \tagstructbegin{tag=H1}%
      \tagmcbegin{tag=H1}%
      {\leftline{\Huge\textbf{\bibname}}}%
      \tagmcend%
      \tagstructend%
      \vspace{40pt}%
      \tagpdfparaOn%
    }%
  }{}%
}