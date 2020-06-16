%%%%%%%%%%%%%%%%%%%%%%%%%
%{

SCRIPT TO EXTRACT TIMING FROM DESIGN FILES AND ACCUMULATE THEM IN ONE CELL ARRAY

1. Use two functions to separately extract numerical and string variables:
   Importdesfile(file)
   Impordesfile_text(file)

2. When this is done, adjust the timing matrices so that trials with no VAS
   are taken into account

3. Finally, convert text conditions to numbers and merge files together in one
   array

4. Accumulate arrays for all participants in one cell structure

%}
%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set up parameters

All_timing={};
FilesDir = '/Users/filip/Documents/MPI CBS/OLF_fMRI/Design_files/'; % Specify base directory where the files are found, ONLY design files can be there because I am using dir function to list them all

%% Start a general loop for all steps

for i=3:length(dir(FilesDir))

%% 1. Use functions Importdesfile and Importdesfile_text to read in the data
    
    Files=dir(FilesDir);
    Timing=Importdesfile([FilesDir,Files(i).name]);
    Text=Importdesfile_text([FilesDir,Files(i).name]);
    
%% 2. Adjust timing matrices to account for trials without VAS

    for j=4:6
        for k=1:46
            if strcmp(Text(2,k),'nein')==1 || strcmp(Text(2,k),'miss')==1 % if someone responded 'no' or misses the response to the perception question, we need to move all the cells by one, because it's not accounted for in the des file
                Timing(j,:)=[Timing(j,1:k-1) NaN Timing(j,k:end-1)]; % construct the whole row anew - take the first part before the 'no' response, then add NaN for where the 'no' response appeared and then paste the rest of the line after that
            end
        end
    end
    
%% 3. Convert text to numbers and merge with Timing file

    for l=7:8
        Timing(l,:)=double(categorical(Text(l-6,:)));
    end
    
    Timing=Timing';
    Timing(46,:)=[];
    
%% 4. Accumulate arrays in one cell structure

    All_timing{i-2,1}=Timing;
    
end



