/**
 * 結帳付款
 *
 * @author:	P-C Lin (a.k.a 高科技黑手)
 */
$(document).ready(function () {
	$('INPUT[name="CreditInstallment"]').change(function () {
		var once = $(this).val() === '0';
		$('INPUT[name="ChoosePayment"]').val(once ? 'ALL' : 'Credit');
		$('INPUT[name="InstallmentAmount"],INPUT[name="Redeem"],INPUT[name="UnionPay"]').attr({disabled: once});
	});
	$('INPUT[type="button"]').click(function () {
		var f = this.form;
		$.post('./', $(f).serialize(), function (d) {
			if (d.reason) {
				alert(d.reason);
			}
			if (d.response && d.result) {
				$(f['recipient']).attr({disabled: true});
				$(f['phone']).attr({disabled: true});
				$(f['address']).attr({disabled: true});
				var r = d.result;
				$(f['MerchantID']).val(r.merchantID);
				$(f['MerchantTradeNo']).val(r.merchantTradeNo);
				$(f['MerchantTradeDate']).val(r.merchantTradeDate);
				$(f['CheckMacValue']).val(r.checkMacValue);
				if ($('INPUT[name="CreditInstallment"]:checked').val() === '0') {
					$(f['CreditInstallment']).remove();
					$(f['InstallmentAmount']).remove();
					$(f['UnionPay']).remove();
				}
				$(f).submit();
			}
		}, 'json');
	});
});