var html_decode = function(str) {
	var _str = '';
	if(typeof(str) == 'undefined') {str = '';}
	str = '' + str;
	if ( str.length == 0 ) return '';
	_str = str.replace(/&/g, '&amp;');
	_str = _str.replace(/</g, '&lt;');
    _str = _str.replace(/>/g, '&gt');
	_str = _str.replace(/"/g, '&quot;');
	return _str;
}
