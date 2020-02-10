module Response
    def json_response messages, is_success, data, status
        render json: {
            json: {
                messages: messages,
                isSuccess: is_success,
                data: data
            }, status: status
        }
    end
end