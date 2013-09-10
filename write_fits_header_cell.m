function[value]=write_fits_header_cell(fid,keys,vals)
%function[value]=write_fits_header_cell(fid,keys,vals)
%write fits header, zero-padding to blocks of 2880

tot_lines=0;
for j=1:length(keys),
  %write_fits_header_line(fid,keys{j},vals{j});
  ll=write_fits_header_line_test(fid,keys{j},vals{j});
  tot_lines=tot_lines+ll;
end
write_fits_header_line(fid,'END','');
nwritten=80*(length(keys)+1);
if (tot_lines>0)
  nwritten=80*(tot_lines+1);
end


n_to_pad=2880-rem(nwritten,2880);
if n_to_pad==2880
  n_to_pad=0;
end


for j=1:n_to_pad,
  fprintf(fid,' ');
end
