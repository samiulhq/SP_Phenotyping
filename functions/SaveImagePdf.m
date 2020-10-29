function SaveImagePdf(plt, l, w, fname, ext, un, res)
% =====       Usage       ======
% Run the function after all necessary plot functions as follows:
%   SaveImagePdf(gcf, 5, 3, 'pics/trash')
%   to save curresnt plot as 'trash.pdf' file with dimentions 5x3 inches
%   into the folder 'pics' of current directory
%
% =====  Required parameters =========
% plt - current graphic file (gcf)
% l - picture length
% w - picture width
% fname - path to store the file
%
% =====  Optional parameters =========
% ext - file format ('pdf' by default)
% un - measurement units ('Inches' by default)
% res - resolution

if nargin < 5
    ext = 'pdf';
end
if nargin < 6
    un = 'centimeters';
end
set(plt, 'color', [1 1 1]);
set(plt, 'PaperUnits', un);
set(plt, 'PaperSize', [l w]);
set(plt, 'PaperPositionMode', 'manual');
set(plt, 'PaperPosition', [0 0 l w]);
saveas(plt,fname,ext);
if nargin > 6
    print('-dtiff',res,fname);
end
