import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class AISearchScreen extends HookWidget {
  const AISearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final searchResults = useState<List<Map<String, dynamic>>>([]);
    final isSearching = useState<bool>(false);

    void runSearch() {
      final query = searchController.text.trim();
      if (query.isEmpty) return;

      isSearching.value = true;
      Future.delayed(const Duration(milliseconds: 800), () {
        searchResults.value = [
          {
            'id': 'doc-101',
            'title': 'Deployment Architecture Spec',
            'type': 'DOCUMENT',
            'score': 0.94,
            'source': 'SEMANTIC_VECTOR',
            'collection': 'Architecture'
          },
          {
            'id': 'doc-202',
            'title': 'Release Runbook - Production',
            'type': 'DOCUMENT',
            'score': 0.88,
            'source': 'SEMANTIC_VECTOR',
            'collection': 'Runbooks'
          },
          {
            'id': 'task-50',
            'title': 'Configure pgvector database tables',
            'type': 'TASK',
            'score': 0.65,
            'source': 'LEXICAL_OPENSEARCH',
            'collection': 'Engineering'
          },
        ];
        isSearching.value = false;
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Unified AI Search', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Search Input Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Enter semantic search terms (e.g. pgvector, deployment)...',
                        hintStyle: TextStyle(color: Color(0xFF64748B)),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => runSearch(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xFF6366F1)),
                    onPressed: runSearch,
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Search Results List
            if (isSearching.value)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF6366F1)),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.value.length,
                  itemBuilder: (context, index) {
                    final item = searchResults.value[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item['type'] == 'TASK' ? Icons.task_alt_rounded : Icons.article_outlined,
                            color: const Color(0xFF6366F1),
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['title'], style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF334155),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(item['collection'], style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                                    ),
                                    const SizedBox(width: 12),
                                    Text('Score: ${item['score']}', style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item['source'],
                              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
