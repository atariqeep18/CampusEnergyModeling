%% Function: Convert a name-value argument list into a structure
% Accepts a name-value argument list (of the type generated by using the
% 'varargin' function option) and creates a structure out of the results.
%
% SYNTAX:
%   out = toStruct(x,varargin)
%
% INPUTS:
%   x =         A cell array of name-value pairs of arguments to convert to
%               a structure
%   varargin =  (Optional) Additional control arguments passed as
%                name-value pairs (see OPTIONAL INPUTS below)
%
% OPTIONAL INPUTS:
%   The following optional inputs may be passed as name-value pairs
%   following 'x':
%
%   'cName', [val]      The name of the class which should be used within
%                       the error message identifier.
%                       (Default = 'general')
%   'validArgs', [val]  A cell array containing valid argument names. Any
%                       arguments not found in this list are ignored (with 
%                       a warning). If no list is provided, no checking is
%                       performed.
%
% OUTPUTS:
%   out =       A structure (object of class 'struct') containing the
%               name-value pairs as fields
% 
% COMMENTS:
% 1. This function is intended to be called internally by other functions,
%    and therefore performs no error checking of its own on the optional
%    arguments.
%
% REFERENCE:
%   S. Frank, "Optimal Design of Mixed AC-DC Distribution Systems for
%   Commercial Buildings," Appendix G, Dissertation, Colorado School of
%   Mines, Golden, CO, 2013. [Online]. Available:
%   http://www.stevefrank.info/publications.html

%% License %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimization of Mixed AC-DC Building Electrical Distribution Systems    %
% Copyright (C) 2013  Stephen M. Frank (stephen.frank@ieee.org)           %
%                                                                         %
% This program is free software: you can redistribute it and/or modify    %
% it under the terms of the GNU General Public License as published by    %
% the Free Software Foundation, either version 3 of the License, or       %
% (at your option) any later version.                                     %
%                                                                         %
% This program is distributed in the hope that it will be useful,         %
% but WITHOUT ANY WARRANTY; without even the implied warranty of          %
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           %
% GNU General Public License for more details.                            %
%                                                                         %
% You should have received a copy of the GNU General Public License       %
% along with this program.  If not, see <http://www.gnu.org/licenses/>.   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = toStruct(x,varargin)
    %% Set Some Defaults   
    % Optional arguments
    cName = 'general';
    validArgs = {};

    %% Process Optional Arguments
    % Parses arguments from 'varargin'
    i = 1;
    if mod(length(varargin),2) > 0
        error(['ACDC:toStruct:mismatchedArgList'], ...
            'All optional arguments must form name-value pairs');
    end
	while i <= length(varargin)
        % Get name-value pair
		argName = varargin{i};
        argVal = varargin{i+1};
        i = i + 2;
        
        % Assign optional values accordingly
        switch argName
			case {'cName'}
                cName = argVal;
			case {'validArgs'}
                validArgs = argVal;
            otherwise
                warning(['ACDC:toStruct:unknownOption'], ...
                    ['Optional argument ''' argName ''' is not ' ...
                     'recognized and has therefore been ignored.']);
        end
	end
    
    %% Check Cell Array
    % Ensure even length
    if mod(length(x),2) > 0
        error(['ACDC:' cName ':mismatchedArgList'], ...
            'All arguments must form name-value pairs');
    end
    
    % Extract names and values
    xNames = x((2:2:length(x))-1);
    xVals  = x((2:2:length(x))  );
    
    % Check that all names are character strings
    for i = 1:length(xNames)
        assert( ischar(xNames{i}), ...
            ['ACDC:' cName ':invalidArgName'], ...
            'All arguments must form name-value pairs');
    end
    
    % Check list of valid arguments, if present
    if ~isempty(validArgs)
        % Drop unrecognized fields
        droppedFields = setdiff( xNames, validArgs );
        [~, cols, ~] = intersect( xNames, validArgs);
        xNames = xNames(cols);
        xVals  = xVals(cols);
        
        % Warning regarding dropped fields
        if ~isempty(droppedFields)
            for i = 1:length(droppedFields)
                warning(['ACDC:' cName ':unrecognizedArgName'], ...
                    ['Argument ''' droppedFields{i} ''' is not ' ...
                     'recognized and has therefore been ignored.']);
            end
        end
    end
    
    %% Create Struct
    % Recreate argument list to feed to struct()
    x = [xNames; xVals];
    x = x(:);
    
    % Create struct
    out = struct(x{:});
end