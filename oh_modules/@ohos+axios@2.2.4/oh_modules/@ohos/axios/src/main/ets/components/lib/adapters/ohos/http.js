/*
 * The MIT License (MIT)
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 */
'use strict';

import buildURL from '../../../lib/helpers/buildURL.js'
import settle from "../../../lib/core/settle"
import AxiosError from '../../../lib/core/AxiosError'
import {setOptions} from './index'
import { LogUtil } from '../../LogUtil'

export default (httpConfig, resolve, reject) => {
    const { httpRequest, fullPath, config } = httpConfig;
    let options = setOptions(config);
    LogUtil.debug(`http url:${fullPath}, options: ${JSON.stringify(options)}`);
    httpRequest.request(
        // 填写http请求的url地址，可以带参数也可以不带参数。URL地址需要开发者自定义。GET请求的参数可以在extraData中指定
        buildURL(fullPath, config.params, config.paramsSerializer), options
        , (err, data) => {
        if (!err) {
            let response = {
                data: data && data.result,
                status: data && data.responseCode,
                statusText: "",
                headers: data && data.header,
                config: config,
                request: httpRequest,
                performanceTiming: data && data.performanceTiming
            };
            settle(function _resolve(value) {
                resolve(value);
            }, function _reject(err) {
                reject(err);
            }, response);
        } else {
            // 发送请求：返回数据大于设置的maxContentLength时与原库保持一致
            if(err.message==='Failed writing received data to disk/application') {
                return reject(new AxiosError(
                    'maxContentLength size of ' + config.maxContentLength + ' exceeded',
                    AxiosError.ERR_BAD_RESPONSE,
                    config,
                    httpRequest
                ));
            }
            // 无网络或者url错误
            reject(new AxiosError(JSON.stringify(err), err.code, config, httpRequest, httpRequest));
        }
        httpRequest.destroy();
    });
}