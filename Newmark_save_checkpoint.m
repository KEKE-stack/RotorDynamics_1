function Newmark_save_checkpoint(filename, settings, step, results, state)
% Write the new checkpoint before replacing the previous one.
folder = fileparts(filename);
if isempty(folder)
    folder = pwd;
end
temporary_file = [tempname(folder) '.mat'];
save(temporary_file, 'settings', 'step', 'results', 'state', '-v7');
[ok, message] = movefile(temporary_file, filename, 'f');
if ~ok
    error('Newmark:CheckpointWriteFailed', ...
        'Cannot replace checkpoint %s. New data were saved to %s. %s', ...
        filename, temporary_file, message);
end
end
