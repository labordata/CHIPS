select 'select group_concat(''update [' || name || '] set ['' || name || ''] = null where ['' || name ||''] = '''''''''', '';
'') || '';
'' as sql_to_run from pragma_table_info('''||name||''');' from sqlite_schema;
