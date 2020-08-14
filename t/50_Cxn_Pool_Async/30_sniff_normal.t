# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

use Test::More;
use Test::Exception;
use Search::Elasticsearch::Async;
use lib 't/lib';
use MockAsyncCxn qw(mock_sniff_client);

## Both nodes respond - check ping before first use

my $t = mock_sniff_client(
    { nodes => [ 'one', 'two' ] },

    { sniff => [ 'one', 'two' ] },
    { sniff => [ 'one', 'two' ] },
    { node => 3, code => 200, content => 1 },
    { node => 4, code => 200, content => 1 },
    { node => 3, code => 200, content => 1 },
    { node => 4, code => 200, content => 1 },
);

ok $t->perform_sync_request()
    && $t->perform_sync_request
    && $t->perform_sync_request
    && $t->perform_sync_request,
    'Sniff before first use';

done_testing;
