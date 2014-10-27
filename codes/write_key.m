function write_key(fid, landmark, value)
if length(value) == 3
    fprintf(fid, '%s : %.1f %.1f %.1f\n', landmark, value(1), value(2), value(3));
else
    fprintf(fid, '%s : %.1f\n', landmark, value);
end
