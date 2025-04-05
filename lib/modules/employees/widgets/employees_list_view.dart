import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:realtime_innovations_project/common/instances.dart';
import 'package:realtime_innovations_project/generated/assets.dart';
import 'package:realtime_innovations_project/modules/employees/bloc/employees_bloc.dart';
import 'package:realtime_innovations_project/modules/employees/widgets/employee_list_tile.dart';

class EmployeesListView extends StatelessWidget {
  const EmployeesListView({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesBloc, EmployeesState>(
      buildWhen: (previous, current) {
        return switch (current) {
          AddedEmployeeState() => true,
          UpdatedEmployeeState() => true,
          GettingEmployeesState() => true,
          DeletedEmployeeState() => true,
          GotEmployeesState() => true,
          RestoredDeletedEmployeeState() => true,
          ErrorGettingEmployeesState() => true,
          _ => false,
        };
      },
      builder: (context, state) {
        final isLoading = state is GettingEmployeesState;
        final isError = state is ErrorGettingEmployeesState;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (isError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Failed to load employees."),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    context.read<EmployeesBloc>().add(GetEmployees());
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        final data = switch (state) {
          GotEmployeesState() => [
              state.currentEmployees ?? [],
              state.previousEmployees ?? [],
            ],
          _ => [
              Instance.employeesRepo.currentEmployeeList ?? [],
              Instance.employeesRepo.previousEmployeeList ?? [],
            ]
        };

        final currentEmployees = data[0];
        final previousEmployees = data[1];

        final isAllEmpty =
            currentEmployees.isEmpty && previousEmployees.isEmpty;

        return RefreshIndicator(
          onRefresh: () async {
            context.read<EmployeesBloc>().add(GetEmployees());
          },
          child: isAllEmpty
              ? Center(child: SvgPicture.asset(Assets.assetsNoEmployess))
              : MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: CustomScrollView(
                    shrinkWrap: true,
                    slivers: [
                      /// Current Employees Section
                      SliverToBoxAdapter(
                        child: Container(
                          color: Color.fromRGBO(242, 242, 242, 1),
                          padding: const EdgeInsets.all(16),
                          child: const Text(
                            "Current employees",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(29, 161, 242, 1),
                            ),
                          ),
                        ),
                      ),
                      if (currentEmployees.isNotEmpty)
                        SliverToBoxAdapter(
                            child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.3, // or whatever max height you want
                                ), // Adjust based on card height (~3 cards)
                                child: ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: currentEmployees.length,
                                  itemBuilder: (context, index) {
                                    final employee = currentEmployees[index];
                                    return EmployeeListTile(
                                      employeeDetailsViewModel: employee,
                                      onEdit: () {
                                        context
                                            .read<EmployeesBloc>()
                                            .add(Navigate(id: employee.id));
                                      },
                                      onDismissed: (direction) {
                                        context.read<EmployeesBloc>().add(
                                            DeleteEmployee(id: employee.id));
                                      },
                                    );
                                  },
                                )))
                      else
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "No current employee records found.",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                        ),

                      /// Previous Employees Section
                      SliverToBoxAdapter(
                        child: Container(
                          color: Color.fromRGBO(242, 242, 242, 1),
                          padding: const EdgeInsets.all(16),
                          child: const Text(
                            "Previous employees",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(29, 161, 242, 1),
                            ),
                          ),
                        ),
                      ),
                      if (previousEmployees.isNotEmpty)
                        SliverToBoxAdapter(
                            child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.sizeOf(context).height * 0.3,
                                ), // or whatever max height you want
                                child: ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: previousEmployees.length,
                                    itemBuilder: (context, index) {
                                      final employee = previousEmployees[index];
                                      return EmployeeListTile(
                                          employeeDetailsViewModel: employee,
                                          onEdit: () {
                                            context
                                                .read<EmployeesBloc>()
                                                .add(Navigate(id: employee.id));
                                          },
                                          onDismissed: (direction) {
                                            context.read<EmployeesBloc>().add(
                                                DeleteEmployee(
                                                    id: employee.id));
                                          });
                                    })))
                      else
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "No previous employee records found.",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                        ),

                      /// Swipe Hint Text
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Swipe left to delete",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
