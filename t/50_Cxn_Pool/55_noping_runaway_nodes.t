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
use Search::Elasticsearch;
use lib 't/lib';
use MockCxn qw(mock_noping_client);

## Runaway nodes

my $t = mock_noping_client(
    { nodes => [ 'one', 'two', 'three' ] },

    { node => 1, code => 200, content => 1 },
    { node => 2, code => 200, content => 1 },
    { node => 3, code => 200, content => 1 },
    { node => 1, code => 509, error   => 'Unavailable' },
    { node => 2, code => 509, error   => 'Unavailable' },
    { node => 3, code => 509, error   => 'Unavailable' },

    # throws unavailable
    { node => 1, code => 200, content => 1 },
    { node => 1, code => 200, content => 1 },
    { node => 2, code => 200, content => 1 },
    { node => 3, code => 200, content => 1 },

);

ok $t->perform_request()
    && $t->perform_request
    && $t->perform_request
    && !eval { $t->perform_request }
    && $@ =~ /Unavailable/
    && $t->perform_request
    && $t->perform_request
    && $t->perform_request
    && $t->perform_request,
    'Runaway nodes';

done_testing;

