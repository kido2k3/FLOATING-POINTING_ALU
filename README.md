<h1 class="code-line" data-line-start=1 data-line-end=2 ><a id="FLOATINGPOINTING_ALU_1"></a>FLOATING-POINTING_ALU</h1>
<h2 class="code-line" data-line-start=3 data-line-end=4 ><a id="Auto_test_manual_3"></a>Auto test manual</h2>
<p class="has-line-data" data-line-start="4" data-line-end="5">In auto_test folder, use the package manager <a href="https://pip.pypa.io/en/stable/">pip</a> to install required modules.</p>
<pre><code class="has-line-data" data-line-start="6" data-line-end="8" class="language-bash">pip install -r requirements.txt
</code></pre>
<ul>
<li class="has-line-data" data-line-start="9" data-line-end="10">Create a testcase in <code>input.txt</code></li>
<li class="has-line-data" data-line-start="10" data-line-end="11">Run <code>build.py</code></li>
<li class="has-line-data" data-line-start="11" data-line-end="12">In testbench file, add the following code:</li>
</ul>
<pre><code class="has-line-data" data-line-start="13" data-line-end="31" class="language-verilog"><span class="hljs-keyword">`</span>define LINK_INPUT <span class="hljs-string">"&lt;fill in&gt;/auto_test/build.txt"</span>
<span class="hljs-keyword">`</span>define LINK_OUTPUT <span class="hljs-string">"&lt;fill in&gt;/auto_test/output_sim.txt"</span>
...
    <span class="hljs-typename">integer</span> fd, f_in;
...
    <span class="hljs-keyword">initial</span> <span class="hljs-keyword">begin</span>
        f_in <span class="hljs-keyword">=</span> $fopen(<span class="hljs-keyword">`</span>LINK_INPUT, <span class="hljs-string">"r"</span>);
        fd <span class="hljs-keyword">=</span> $fopen(<span class="hljs-keyword">`</span>LINK_OUTPUT, <span class="hljs-string">"w"</span>);
        $fmonitorh(fd, out);
        <span class="hljs-keyword">while</span> (<span class="hljs-keyword">!</span>$feof(f_in)) <span class="hljs-keyword">begin</span>
            $fscanf(f_in, <span class="hljs-string">"%h %h\n"</span>, para1, para2);
            <span class="hljs-keyword">#</span><span class="hljs-number">1</span>;
        <span class="hljs-keyword">end</span>
        $fclose(f_in);
        $fclose(fd);
        $finish;
    <span class="hljs-keyword">end</span>
</code></pre>
<ul>
<li class="has-line-data" data-line-start="31" data-line-end="32">Run testbench file</li>
<li class="has-line-data" data-line-start="32" data-line-end="33">Run <code>check.py</code> file</li>
<li class="has-line-data" data-line-start="33" data-line-end="34">The result is displayed in <code>final_result.txt</code></li>
</ul>
<pre><code class="has-line-data" data-line-start="35" data-line-end="40" class="language-diff"><span class="hljs-deletion">- NOTE:</span>
<span class="hljs-deletion">- A line (testcase) format in input.txt: &lt;para1&gt; &lt;para2&gt;</span>
<span class="hljs-deletion">- Example testcases are saved in multi_TestCase folder</span>
<span class="hljs-deletion">- testcase5 (overflow), and testcase6 (underflow) are used for build.txt, not input.txt. In this case, only run testbench file and obverse the test console</span>
</code></pre>
