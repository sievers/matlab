function[value]=dd2dms_string(dec)
[dd,dm,ds]=dd2dms(dec);
value=[dd ':' dm ':' ds];
