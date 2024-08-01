
import 'package:logistics_app/delivery/models/order.dart';

class Request {
    String? messageType;
    Content? content;

    Request({this.messageType, this.content});

    Request.fromJson(Map<String, dynamic> json) {
        messageType = json["messageType"];
        content = json["content"] == null ? null : Content.fromJson(json["content"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["messageType"] = messageType;
        if(content != null) {
            _data["content"] = content?.toJson();
        }
        return _data;
    }
}

class Content {
    String? requestId;
    Order? order;

    Content({this.requestId, this.order});

    Content.fromJson(Map<String, dynamic> json) {
        requestId = json["requestId"];
        order = json["order"] == null ? null : Order.fromJson(json["order"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["requestId"] = requestId;
        if(order != null) {
            _data["order"] = order?.toJson();
        }
        return _data;
    }
}