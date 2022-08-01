import 'dart:convert';

class TestTemplate {
  void test() {
    String da = """{
                    "viewAttr": {
                    "expandStatus": "true",
                    "textList": ["车架号", "LS234834239784392"],
                    "titleColor": "0xff666768",
                    "type": "label"
                   },
                   "params": null,
                   "actions": [{
                    "type": null
                   }]
                  }""";

    var mm = jsonDecode(da);
    print("runType = ${mm.runtimeType}");

    String data2 = """{
	"extraMap": {},
	"top": {
		"center": {
			"viewAttr": {
				"title": "审批轨迹"
			}
		},
		"right": [{
			"viewAttr": {
				"type": "hiddenTrigger"
			}
		}]
	},
	"content": [{
		"viewAttr": {
			"licenseNo": "辽DZ0001",
			"cardState": "待提交",
			"type": "card_voucher_header",
			"cardTitle": "返厂无忧E大额（激活）"
		}
	}, {
		"viewAttr": {
			"expandStatus": "true",
			"type": "labelRow",
			"title": "案件信息"
		},
		"actions": [{
			"expandFlag": "display1",
			"type": "expandable"
		}]
	}, {
		"viewAttr": {
			"expandStatus": "true",
			"expandFlag": "display1",
			"type": "twoLabelRow",
			"title": "车险报案号",
			"content": "Tdkv"
		}
	}, {
		"viewAttr": {
			"expandStatus": "true",
			"expandFlag": "display1",
			"type": "twoLabelRow",
			"title": "车架号",
			"content": "FHUIIUKJIUGGU8885"
		}
	}, {
		"viewAttr": {
			"expandStatus": "true",
			"expandFlag": "display1",
			"type": "twoLabelRow",
			"title": "出险日期",
			"content": "2022-07-25"
		}
	}, {
		"viewAttr": {
			"expandStatus": "true",
			"expandFlag": "display1",
			"type": "twoLabelRow",
			"title": "报案人",
			"content": "应逸之",
			"hiddenInfo": "name"
		}
	}, {
		"viewAttr": {
			"expandStatus": "true",
			"expandFlag": "display1",
			"type": "twoLabelRow",
			"title": "报案人联系电话",
			"content": "13916917857",
			"hiddenInfo": "phone"
		}
	}, {
		"viewAttr": {
			"expandStatus": "true",
			"expandFlag": "display1",
			"type": "twoLabelRow",
			"title": "损失金额",
			"content": ""
		}
	}, {
		"viewAttr": {
			"expandStatus": "true",
			"expandFlag": "display1",
			"type": "twoLabelRow",
			"title": "赔付金额",
			"content": "0"
		}
	}, {
		"viewAttr": {
			"type": "divider"
		}
	}, {
		"viewAttr": {
			"expandStatus": "true",
			"type": "labelRow",
			"title": "银行信息"
		},
		"actions": [{
			"expandFlag": "display2",
			"type": "expandable"
		}]
	}, {
		"viewAttr": {
			"expandStatus": "true",
			"expandFlag": "display2",
			"type": "twoLabelRow",
			"title": "开户银行",
			"content": "中国银行"
		}
	}, {
		"viewAttr": {
			"expandStatus": "true",
			"expandFlag": "display2",
			"type": "twoLabelRow",
			"title": "开户支行",
			"content": "148528445521232152"
		}
	}, {
		"viewAttr": {
			"expandStatus": "true",
			"expandFlag": "display2",
			"type": "twoLabelRow",
			"title": "户名",
			"content": "张三"
		}
	}, {
		"viewAttr": {
			"expandStatus": "true",
			"expandFlag": "display2",
			"type": "twoLabelRow",
			"title": "账号",
			"content": "362936283628363820"
		}
	}, {
		"viewAttr": {
			"type": "divider"
		}
	}]
}""";

    Map map = jsonDecode(data2);
    List map2 = map['content'];
    map2.add(mm);
    print("---- size = ${map2.length}");
  }
}
