/**
 * @author	P-C Lin (a.k.a 高科技黑手)
 */
$(document).ready(function () {
	/**
	 * 翻頁器
	 */
	$('FORM#pagination A.paginate').click(function (e) {
		e.preventDefault();
		var p = $(this).attr('tabindex');
		$(this).parents('FORM').find('SELECT[name="p"] OPTION').each(function () {
			if ($(this).val() === p) {
				$(this).siblings('OPTION:selected').removeAttr('selected');
				$(this).attr({selected: true});
				this.form.submit();
			}
		});
		return false;
	});

	/**
	 * 跳頁器
	 */
	$('FORM#pagination SELECT[name="p"]').change(function () {
		this.form.submit();
	});

	/**
	 * 僅數字
	 */
	$('INPUT[type="text"].numeric').keyup(function () {
		$(this).val($(this).val().replace(/\D/g, ''));
	});
});